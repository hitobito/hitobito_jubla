require 'spec_helper'

describe PeopleController do
  let(:person) { role.person }
  let(:role)   { roles(:flock_leader) }
  let(:flock)  { groups(:innerroden) }
  let(:alumni) { groups(:innerroden_ehemalige) }

  before { sign_in(person) }

  it 'allows setting of contactable flags' do
    post :update, group_id: flock.id, id: person.id, person: {
      contactable_by_federation: 1,
      contactable_by_state: 1,
      contactable_by_region: 1,
      contactable_by_flock: 1
    }
    expect(person.reload).to be_contactable_by_federation
    expect(person.reload).to be_contactable_by_state
    expect(person.reload).to be_contactable_by_region
    expect(person.reload).to be_contactable_by_flock
  end



  context 'with alumnus role' do
    render_views

    it 'GET#show renders contactable info' do
      Fabricate(Group::FlockAlumnusGroup::Member.sti_name, group: groups(:ausserroden_ehemalige), person: person)
      get :show, group_id: flock.id, id: person.id
      expect(response.body).to match /Kontaktfreigabe/
    end

    it 'GET#edit renders contactable fields' do
      Fabricate(Group::FlockAlumnusGroup::Member.sti_name, group: groups(:ausserroden_ehemalige), person: person)
      get :edit, group_id: flock.id, id: person.id
      expect(response.body).to match /erlaubst du folgenden Ebenen, dich zu kontaktieren/
    end
  end

  context 'without alumnus role' do
    render_views

    it 'GET#show hides contactable info for only active roles' do
      get :show, group_id: flock.id, id: person.id
      expect(response.body).not_to match /Kontaktfreigabe/
    end

    it 'GET#edit hides contactable fields for alumnus role' do
      get :edit, group_id: flock.id, id: person.id
      expect(response.body).not_to match /erlaubst du folgenden Ebenen, dich zu kontaktieren/
    end
  end

end
