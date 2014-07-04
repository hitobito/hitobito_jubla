# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::Group
  extend ActiveSupport::Concern

  included do
    class_attribute :contact_group_type

    self.used_attributes += [:bank_account]

    has_many :course_conditions, class_name: '::Event::Course::Condition', dependent: :destroy

    # define global children
    children Group::SimpleGroup

    root_types Group::Federation
  end

  def census?
    respond_to?(:census_total)
  end
end
