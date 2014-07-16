class AddOriginatingStateAndFlockToPerson < ActiveRecord::Migration
  def change
    add_column(:people, :originating_state_id, :integer)
    add_column(:people, :originating_flock_id, :integer)
    say_with_time "Updating #{Person.count} People ..." do
      Person.includes(:roles).all.each { |person| person.update_columns(GroupOriginator.new(person).to_h) }
    end
  end
end
