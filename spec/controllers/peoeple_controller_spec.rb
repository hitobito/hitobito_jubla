require 'spec_helper'

describe PeopleController do
  let(:group) { groups(:federal_board) }
  let(:top_leader) { people(:top_leader) }

  before { sign_in(top_leader) }

  it 'allows setting of contactable flags' do
    post :update, group_id: group.id, id: top_leader.id, person: {
      contactable_by_federation: 1,
      contactable_by_state: 1,
      contactable_by_region: 1,
      contactable_by_flock: 1
    }
    expect(top_leader.reload).to be_contactable_by_federation
    expect(top_leader.reload).to be_contactable_by_state
    expect(top_leader.reload).to be_contactable_by_region
    expect(top_leader.reload).to be_contactable_by_flock
  end

end
