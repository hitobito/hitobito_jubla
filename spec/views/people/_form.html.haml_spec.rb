require 'spec_helper'
describe 'people/_form.html.haml' do

  let(:group) { groups(:federal_board) }
  let(:top_leader) { people(:top_leader) }

  subject do
    allow(controller).to receive_messages(current_user: top_leader)
    allow(view).to receive_messages(path_args: [group, top_leader])
    allow(view).to receive_messages(model_class: Person)
    allow(view).to receive(:entry).and_return(top_leader)
    render
    Capybara::Node::Simple.new(@rendered)
  end

  it 'hides contactable fields if active roles exist' do
    is_expected.not_to have_field :person_contactable_by_federation
    is_expected.not_to have_field :person_contactable_by_state
    is_expected.not_to have_field :person_contactable_by_region
    is_expected.not_to have_field :person_contactable_by_flock
  end

  it 'shows contactable fields if only alumnus roles exist' do
    top_leader.roles.destroy_all
    top_leader.roles.create!(type: 'Group::FederalAlumnusGroup::Member', group: groups(:ch_ehemalige))
    is_expected.to have_field :person_contactable_by_federation
    is_expected.to have_field :person_contactable_by_state
    is_expected.to have_field :person_contactable_by_region
    is_expected.to have_field :person_contactable_by_flock
  end
end
