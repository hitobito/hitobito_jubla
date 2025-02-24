class RequireAddRequestsOnAllGroups < ActiveRecord::Migration[7.1]
  def up
    execute "UPDATE groups SET require_person_add_requests = TRUE"
    change_column_default :groups, :require_person_add_requests, true
  end

  def down
    change_column_default :groups, :require_person_add_requests, false
  end
end
