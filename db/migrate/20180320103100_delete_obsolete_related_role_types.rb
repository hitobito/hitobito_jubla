class DeleteObsoleteRelatedRoleTypes < ActiveRecord::Migration[4.2]
  def change
    execute statement
  end

  def statement
    <<-SQL.strip_heredoc
      DELETE FROM related_role_types
      WHERE role_type LIKE '%::Alumnus'
    SQL
  end
end
