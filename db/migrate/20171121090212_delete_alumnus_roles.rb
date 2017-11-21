class DeleteAlumnusRoles < ActiveRecord::Migration
  def up
    execute("DELETE FROM roles WHERE type LIKE '%::Alumnus'")
  end
end
