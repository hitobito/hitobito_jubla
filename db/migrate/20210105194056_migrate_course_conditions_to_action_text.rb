class MigrateCourseConditionsToActionText < ActiveRecord::Migration[6.0]
  include ActionView::Helpers::TextHelper

  def change
    rename_column :event_conditions, :content, :content_old
    Event::Course::Condition.find_each do |cct|
      cct.update_attribute(:content, simple_format(cct.content))
    end
    remove_column :event_conditions, :content_old
  end
end
