class MigrateCourseConditionsToActionText < ActiveRecord::Migration[6.0]
  include ActionView::Helpers::TextHelper

  def change
    rename_column :event_conditions, :content, :content_old
    binding.pry
    Event::Course::Condition.find_each do |cct|
      cct.update(content: simple_format(cct.content_old))
    end
    remove_column :event_conditions, :content_old
    Event::Course::Condition.reset_column_information
  end
end
