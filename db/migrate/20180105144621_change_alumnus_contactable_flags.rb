class ChangeAlumnusContactableFlags < ActiveRecord::Migration[4.2]
  def up
    change_table(:people) do |t|
      t.change_default(:contactable_by_federation, true)
      t.change_default(:contactable_by_state, true)
      t.change_default(:contactable_by_region, true)
      t.change_default(:contactable_by_flock, true)
    end
    execute('UPDATE people SET contactable_by_federation = true, ' \
            'contactable_by_state = true, contactable_by_region = true, ' \
            'contactable_by_flock = true')
  end

  def down
    change_table(:people) do |t|
      t.change_default(:contactable_by_federation, false)
      t.change_default(:contactable_by_state, false)
      t.change_default(:contactable_by_region, false)
      t.change_default(:contactable_by_flock, false)
    end
    execute('UPDATE people SET contactable_by_federation = false, ' \
            'contactable_by_state = false, contactable_by_region = false, ' \
            'contactable_by_flock = false')
  end
end
