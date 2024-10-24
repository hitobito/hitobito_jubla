#  Copyright (c) 2012-2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::Group
  extend ActiveSupport::Concern

  ALUMNI_GROUPS_CLASSES = [Group::AlumnusGroup,
    Group::StateAlumnusGroup,
    Group::FederalAlumnusGroup,
    Group::FlockAlumnusGroup,
    Group::RegionalAlumnusGroup].map(&:sti_name)

  included do
    class_attribute :contact_group_type

    # Clear class attribute to customize it just for Jubla
    self.protect_if_methods = {}

    protect_if :root?
    protect_if :children_without_deleted_and_alumni_groups

    before_destroy :delete_alumni_groups
    after_create :create_alumni_filter, unless: :alumnus?

    scope :alumni_groups, -> { where(type: ALUMNI_GROUPS_CLASSES) }
    scope :without_alumni_groups, -> { where.not(type: ALUMNI_GROUPS_CLASSES) }

    self.used_attributes += [:bank_account]

    has_many :course_conditions, class_name: "::Event::Course::Condition", dependent: :destroy

    # define global children
    children Group::SimpleGroup

    root_types Group::Root, Group::Federation, Group::Nejb

    private

    def delete_alumni_groups
      alumni_groups = children.where(type: ALUMNI_GROUPS_CLASSES)
      # Hard delete alumni roles because the alumni groups are also hard deleted
      Role.with_deleted.where(group_id: alumni_groups.select(:id)).delete_all
      alumni_groups.delete_all
    end
  end

  def alumnus_class
    "#{self.class.name}::Alumnus".constantize
  end

  def alumnus_member_class
    "#{alumnus_group.type}::Member".constantize
  end

  def alumnus_group
    @alumnus_group ||= alumni_groups.first
  end

  def alumni_groups
    groups_in_same_layer.where(type: ALUMNI_GROUPS_CLASSES)
  end

  def alumnus?
    is_a?(Group::AlumnusGroup)
  end

  def census?
    respond_to?(:census_total)
  end

  def children_without_deleted_and_alumni_groups
    children.without_deleted.without_alumni_groups
  end

  def create_alumni_filter
    people_filters.create!(name: "Ehemalige",
      group_id: id,
      range: :group,
      filter_chain: alumni_filter_chain)
  end

  def alumni_filter_chain
    {role: {
      kind: "deleted",
      start_at: Time.zone.at(0).to_s,
      role_types: self.class.roles.collect(&:sti_name)
    }}
  end
end
