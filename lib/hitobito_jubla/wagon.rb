# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module HitobitoJubla
  class Wagon < Rails::Engine
    include Wagons::Wagon

    # Set the required application version.
    app_requirement '>= 0'

    # Add a load path for this specific wagon
    config.autoload_paths += %W( #{config.root}/app/abilities
                                 #{config.root}/app/domain
                                 #{config.root}/app/jobs
                                 #{config.root}/app/serializers
                               )

    # extend application classes here
    config.to_prepare do
      ### models
      Group.send  :include, Jubla::Group
      Role.send   :include, Jubla::Role
      Person.send :include, Jubla::Person
      Event::Course.send :include, Jubla::Event::Course
      Event::Application.send :include, Jubla::Event::Application

      ### abilities
      EventAbility.send :include, Jubla::EventAbility
      Event::ParticipationAbility.send :include, Jubla::Event::ParticipationAbility
      Event::RoleAbility.send :include, Jubla::Event::RoleAbility
      GroupAbility.send :include, Jubla::GroupAbility
      PersonAbility.send :include, Jubla::PersonAbility
      VariousAbility.send :include, Jubla::VariousAbility

      # load this class after all abilities have been defined
      Ability.store.register Event::Course::ConditionAbility

      PersonSerializer.send :include, Jubla::PersonSerializer
      GroupSerializer.send  :include, Jubla::GroupSerializer

      # domain
      Bsv::Info.send :include, Jubla::Bsv::Info

      Export::Csv::Events::List.send :include, Jubla::Export::Csv::Events::List
      Export::Csv::Events::Row.send :include, Jubla::Export::Csv::Events::Row
      Export::Csv::People::PersonRow.send :include, Jubla::Export::Csv::People::OriginatingGroups
      Export::Csv::People::ParticipationRow.send :include, Jubla::Export::Csv::People::OriginatingGroups
      Export::Csv::Events::BsvList.send :include, Jubla::Export::Csv::Events::BsvList
      Export::Csv::Events::BsvRow.send :include, Jubla::Export::Csv::Events::BsvRow

      Export::Pdf::Participation.send :include, Jubla::Export::Pdf::Participation
      Export::Pdf::Participation.runner = Jubla::Export::Pdf::Participation::Runner
      Event::ParticipationFilter.load_entries_includes += [
        person: [:originating_flock, :originating_state]
      ]

      ### controllers
      PeopleController.permitted_attrs += [
        :name_mother, :name_father, :nationality, :profession, :canton, :bank_account,
        :ahv_number, :ahv_number_old, :j_s_number, :insurance_company, :insurance_number]
      Event::Camp::KindsController # load before Event::KindsController
      Event::KindsController.permitted_attrs += [:j_s_label]

      GroupsController.send :include, Jubla::GroupsController
      EventsController.send :include, Jubla::EventsController
      Event::ListsController.bsv_course_states = Event::Course.possible_states
      Event::ApplicationMarketController.send :include, Jubla::Event::ApplicationMarketController
      Event::QualificationsController.send :include, Jubla::Event::QualificationsController
      Event::RegisterController.send :include, Jubla::Event::RegisterController
      Event::ParticipationsController.send :include, Jubla::Event::ParticipationsController
      Subscriber::GroupController.send :include, Jubla::Subscriber::GroupController

      ### decorators
      Event::ParticipationDecorator.send :include, Jubla::Event::ParticipationDecorator
      EventDecorator.send :include, Jubla::EventDecorator
      PersonDecorator.send :include, Jubla::PersonDecorator

      ### helpers
      # add more active_for urls to main navigation
      NavigationHelper::MAIN[:admin][:active_for] << 'event_camp_kinds'
      Sheet::Group.send :include, Jubla::Sheet::Group
    end

    initializer 'jubla.add_settings' do |_app|
      Settings.add_source!(File.join(paths['config'].existent, 'settings.yml'))
      Settings.reload!
    end

    initializer 'jubla.add_inflections' do |_app|
      ActiveSupport::Inflector.inflections do |inflect|
        inflect.irregular 'census', 'censuses'
      end
    end

    private

    def seed_fixtures
      fixtures = root.join('db', 'seeds')
      ENV['NO_ENV'] ? [fixtures] : [fixtures, File.join(fixtures, Rails.env)]
    end
  end
end
