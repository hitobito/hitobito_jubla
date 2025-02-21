class RequireAddRequestsOnAllGroups < ActiveRecord::Migration[7.1]
  def change
    execute "UPDATE groups SET require_person_add_requests = TRUE"
  end
end
