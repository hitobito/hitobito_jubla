# frozen_string_literal: true

#  Copyright (c) 2012-2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module HitobitoJubla
  class Wagon < Rails::Engine
    include Wagons::Wagon

    # Set the required application version.
    app_requirement ">= 0"

    # Add a load path for this specific wagon
    config.autoload_paths += %W[
      #{config.root}/app/abilities
      #{config.root}/app/domain
      #{config.root}/app/jobs
      #{config.root}/app/serializers
    ]

    # extend application classes here
    config.to_prepare do # rubocop:disable Metrics/BlockLength This is config
      ### models
      Group.include Jubla::Group
      Role.include Jubla::Role
      Person.include Jubla::Person
      Event.include Jubla::Event
      Event::Course.include Jubla::Event::Course
      Event::Application.include Jubla::Event::Application
      Event::Role::Helper.qualifiable = true # According to https://github.com/hitobito/hitobito_jubla/issues/33

      TableDisplay.register_column(Event::Participation,
        TableDisplays::ShowFullColumn,
        [:ahv_number, :j_s_number, :canton]
          .map { |col| "person.#{col}" })

      ### abilities
      EventAbility.include Jubla::EventAbility
      Event::ParticipationAbility.include Jubla::Event::ParticipationAbility
      Event::RoleAbility.include Jubla::Event::RoleAbility
      GroupAbility.include Jubla::GroupAbility
      PersonAbility.include Jubla::PersonAbility
      VariousAbility.include Jubla::VariousAbility
      RoleAbility.include Jubla::RoleAbility
      PersonReadables.include Jubla::PersonReadables
      GroupBasedFetchables.include Jubla::GroupBasedFetchables

      # load this class after all abilities have been defined
      Ability.store.register Event::Course::ConditionAbility

      PersonSerializer.include Jubla::PersonSerializer
      GroupSerializer.include Jubla::GroupSerializer

      # domain
      Bsv::Info.include Jubla::Bsv::Info
      Person::EventQueries.include Jubla::Person::EventQueries

      Export::Tabular::Events::List.include Jubla::Export::Tabular::Events::List
      Export::Tabular::Events::Row.include Jubla::Export::Tabular::Events::Row
      Export::Tabular::People::PersonRow.include Jubla::Export::Tabular::People::OriginatingGroups
      Export::Tabular::People::ParticipationRow.include(
        Jubla::Export::Tabular::People::OriginatingGroups
      )
      Export::Tabular::Events::BsvList.include Jubla::Export::Tabular::Events::BsvList
      Export::Tabular::Events::BsvRow.include Jubla::Export::Tabular::Events::BsvRow

      Group::Merger.include Jubla::Group::Merger
      Group::Mover.include Jubla::Group::Mover

      Export::Pdf::Participation.include Jubla::Export::Pdf::Participation
      Export::Pdf::Participation.runner = Jubla::Export::Pdf::Participation::Runner
      Event::ParticipationFilter.load_entries_includes += [
        person: [:originating_flock, :originating_state]
      ]

      JobManager.wagon_jobs += [
        AlumniManagerJob
      ]

      MailingLists::Subscribers.include Jubla::MailingLists::Subscribers
      Person::Filter::List.include Jubla::Person::Filter::List

      Import::PersonImporter.include Jubla::Import::PersonImporter

      ### controllers
      PeopleController.permitted_attrs += [
        :name_mother, :name_father, :nationality, :profession, :canton, :bank_account,
        :ahv_number, :ahv_number_old, :j_s_number, :insurance_company, :insurance_number,
        :contactable_by_federation, :contactable_by_state, :contactable_by_region,
        :contactable_by_flock
      ]

      RolesController.include Jubla::RolesController

      Event::Camp::KindsController # rubocop:disable Lint/Void load before Event::KindsController
      Event::KindsController.permitted_attrs += [:j_s_label]

      GroupsController.include Jubla::GroupsController
      EventsController.include Jubla::EventsController
      Event::ApplicationMarketController.include Jubla::Event::ApplicationMarketController
      Event::QualificationsController.include Jubla::Event::QualificationsController
      Event::RegisterController.include Jubla::Event::RegisterController
      Event::ParticipationsController.include Jubla::Event::ParticipationsController

      ### decorators
      Event::ParticipationDecorator.include Jubla::Event::ParticipationDecorator

      EventDecorator.icons["Event::Camp"] = :campground
      EventDecorator.include Jubla::EventDecorator
      PersonDecorator.include Jubla::PersonDecorator

      ### helpers
      # add more active_for urls to main navigation
      admin = NavigationHelper::MAIN.find { |opts| opts[:label] == :admin }
      admin[:active_for] << "event_camp_kinds"
      i = NavigationHelper::MAIN.index { |opts| opts[:label] == :courses }
      NavigationHelper::MAIN.insert(
        i + 1,
        label: :camps,
        icon_name: :campground,
        url: :list_camps_path,
        active_for: %w[list_all_camps
          list_state_camps],
        if: lambda do |_|
          can?(:list_all_camps, Event::Camp) ||
            can?(:list_state_camps, Event::Camp)
        end
      )
      Sheet::Group.include Jubla::Sheet::Group
    end

    initializer "jubla.add_settings" do |_app|
      Settings.add_source!(File.join(paths["config"].existent, "settings.yml"))
      Settings.reload!
    end

    initializer "jubla.add_inflections" do |_app|
      ActiveSupport::Inflector.inflections do |inflect|
        inflect.irregular "census", "censuses"
      end
    end

    private

    def seed_fixtures
      fixtures = root.join("db", "seeds")
      ENV["NO_ENV"] ? [fixtures] : [fixtures, File.join(fixtures, Rails.env)]
    end
  end
end
