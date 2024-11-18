require "spec_helper"

describe PersonDecorator do
  let(:person) { role.person }
  let(:role) { roles(:flock_leader) }
  let(:flock) { groups(:innerroden) }
  let(:alumni) { groups(:innerroden_ehemalige) }

  it "active role is considered active" do
    expect(person.decorate.active_roles_grouped[flock]).to eq [role]
    expect(person.decorate.inactive_roles_grouped).to be_empty
  end

  it "alumnus leader role is considered active" do
    role = Fabricate(Group::FlockAlumnusGroup::Leader.sti_name, group: alumni, person: person)
    expect(person.decorate.active_roles_grouped[alumni]).to eq [role]
    expect(person.decorate.inactive_roles_grouped).to be_empty
  end

  it "alumnus group member role is considered as nothing" do
    role.delete
    Fabricate(Group::FlockAlumnusGroup::Member.sti_name, group: alumni, person: person)
    expect(person.decorate.active_roles_grouped).not_to have_key(alumni)
    expect(person.decorate.inactive_roles_grouped).not_to have_key(alumni)
  end

  it "any alumnus role is considered inactive" do
    role.delete
    Fabricate(Group::Flock::Alumnus.sti_name, group: groups(:bern), person: person)
    expect(person.decorate.active_roles_grouped).not_to have_key(groups(:bern))
    expect(person.decorate.inactive_roles_grouped).to have_key(groups(:bern))
  end
end
