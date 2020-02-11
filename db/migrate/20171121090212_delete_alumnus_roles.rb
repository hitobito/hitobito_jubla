class DeleteAlumnusRoles < ActiveRecord::Migration[4.2]
  def up
    execute("DELETE FROM roles WHERE type LIKE '%::Alumnus'")
  end
end
