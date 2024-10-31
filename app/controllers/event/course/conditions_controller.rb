#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class Event::Course::ConditionsController < SimpleCrudController
  self.nesting = Group

  self.permitted_attrs = [:content, :label]
  self.sort_mappings = {content: {joins: [:rich_text_content], order: ["action_text_rich_texts.body"]}}

  helper_method :group

  decorates :group

  prepend_before_action :parent

  private

  def list_entries
    super.includes(:group, :rich_text_content).order(:label)
  end

  def group
    @group ||= parent
  end

  def index_path
    group_event_course_conditions_path(group, returning: true)
  end

  def assign_attributes
    super
    entry.group = group
  end

  def parent_scope
    group.course_conditions
  end

  def authorize_class
    authorize!(:index_event_course_conditions, group)
  end

  class << self
    def model_class
      Event::Course::Condition
    end
  end
end
