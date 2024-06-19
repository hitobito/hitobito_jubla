require 'spec_helper'

describe PeopleController do
  let(:person) { role.person }
  let(:role)   { roles(:flock_leader) }
  let(:flock)  { groups(:innerroden) }
  let(:alumni) { groups(:innerroden_ehemalige) }

  before { sign_in(person) }

  it 'allows setting of contactable flags' do
    post :update, params: { group_id: flock.id, id: person.id, person: {
      contactable_by_federation: 1,
      contactable_by_state: 1,
      contactable_by_region: 1,
      contactable_by_flock: 1
    } }
    expect(person.reload).to be_contactable_by_federation
    expect(person.reload).to be_contactable_by_state
    expect(person.reload).to be_contactable_by_region
    expect(person.reload).to be_contactable_by_flock
  end


  context 'GET#show' do
    render_views

    it 'GET#show hides contactable info for alumnus and active roles' do
      Fabricate(Group::Flock::Alumnus.sti_name, group: flock, person: person)
      get :show, params: { group_id: flock.id, id: person.id }
      expect(response.body).not_to match(/Kontaktfreigabe/)
    end

    it 'GET#show shows contactable info for alumnus and active roles' do
      role.really_delete
      Fabricate(Group::Flock::Alumnus.sti_name, group: flock, person: person)
      get :show, params: { group_id: flock.id, id: person.id }
      expect(response.body).to match(/Kontaktfreigabe/)
    end

    it 'GET#show shows primary group link' do
      get :show, params: { group_id: flock.id, id: person.id }
      expect(Capybara::Node::Simple.new(response.body)).to have_link 'Hauptgruppe setzen'
    end
  end

  context 'GET#edit' do
    render_views

    it 'GET#edit hides contactable info for alumnus and active roles' do
      Fabricate(Group::Flock::Alumnus.sti_name, group: flock, person: person)
      get :edit, params: { group_id: flock.id, id: person.id }
      expect(response.body).not_to match(/erlaubst du folgenden Ebenen, dich zu kontaktieren/)
    end

    it 'GET#edit shows contactable info for alumnus and active roles' do
      role.really_delete
      Fabricate(Group::Flock::Alumnus.sti_name, group: flock, person: person)
      get :edit, params: { group_id: flock.id, id: person.id }
      expect(response.body).to match(/erlaubst du folgenden Ebenen, dich zu kontaktieren/)
    end
  end

end
