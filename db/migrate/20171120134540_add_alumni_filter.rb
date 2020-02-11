class AddAlumniFilter < ActiveRecord::Migration[4.2]
  def up
    Group.find_each do |group|
      next if group.alumnus?
      group.create_alumni_filter
    end
  end

  def down
    Group.find_each do |group|
      next if group.alumnus?
      group.people_filters.where(name: 'Ehemalige').destroy_all
    end
  end
end
