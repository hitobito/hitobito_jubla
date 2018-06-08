# encoding: utf-8

#  Copyright (c) 2017, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

require 'spec_helper'

describe Jubla::Person::Filter::List do
  let(:person) { Fabricate(:person) }

  [[Group::FlockAlumnusGroup::Member, :bern_ehemalige],
   [Group::Flock::Alumnus, :bern]].each do |role_type, role_group|
    context "#{role_type}" do

      %w(ch be city bern).zip(%w(federation state region flock)).each do |group, layer|
        let(:alumnus) { Fabricate(role_type.name, group: groups(role_group), person: person) }

        context "contactable_by_#{layer}" do

          it "true includes alumnus role" do
            alumnus.person.update("contactable_by_#{layer}" => true)
            filter = list_filter(group, role_type)
            expect(filter.entries).to include(alumnus.person)
          end

          it "false does not include alumnus role" do
            alumnus.person.update("contactable_by_#{layer}" => false)
            filter = list_filter(group, role_type)
            expect(filter.entries).to be_empty
          end

          next unless role_type == Group::Flock::Alumnus

          it "false includes alumnus role, if it has another active role" do
            Fabricate(Group::Flock::Leader.name, group: groups(:bern), person: person)
            alumnus.person.update("contactable_by_#{layer}" => false)
            filter = list_filter(group, role_type, Group::Flock::Leader)
            expect(alumnus.reload).to be_present # role still exists
            expect(filter.entries).to include(alumnus.person)
          end
        end
      end
    end
  end

  def list_filter(group, *roles)
    Person::Filter::List.new(groups(group), people(:top_leader), build_params(roles))
  end

  def build_params(roles)
    {
      range: 'deep',
      filters: {
        role: { role_type_ids: roles.collect(&:id).join('-') }
    }
  }
end

end
