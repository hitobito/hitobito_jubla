# encoding: utf-8

#  Copyright (c) 2012-2017, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'


# Specs for listing and searching people
describe PersonReadables do


  [:index, :layer_search, :deep_search, :global].each do |action|
    context action do
      let(:action) { action }
      let(:user)   { role.person.reload }
      let(:ability) { PersonReadables.new(user, action == :index ? group : nil) }

      let(:all_accessibles) do
        people = Person.accessible_by(ability)
        case action
        when :index then people
        when :layer_search then people.in_layer(group.layer_group)
        when :deep_search then people.in_or_below(group.layer_group)
        when :global then people
        end
      end


      subject { all_accessibles }

      describe :layer_and_below_full do
        let(:role) { Fabricate(Group::FederalBoard::Member.name.to_sym, group: groups(:federal_board)) }

        it 'has layer and below full permission' do
          expect(role.permissions).to include(:layer_and_below_full)
        end

        context 'own group' do
          let(:group) { role.group }

          it 'may get himself' do
            is_expected.to include(role.person)
          end

          it 'may get people in his group' do
            other = Fabricate(Group::FederalBoard::Member.name.to_sym, group: group)
            is_expected.to include(other.person)
          end

          it 'may get external people in his group' do
            other = Fabricate(Group::FederalBoard::External.name.to_sym, group: group)
            is_expected.to include(other.person)
          end
        end

        context 'lower group' do
          let(:group) { groups(:be_board) }

          it 'may get visible people' do
            other = Fabricate(Group::StateBoard::Leader.name.to_sym, group: group)
            is_expected.to include(other.person)
          end

          it 'may not get external people' do
            other = Fabricate(Group::StateBoard::External.name.to_sym, group: group)
            is_expected.not_to include(other.person)
          end
        end
      end


      describe :layer_and_below_read do
        let(:role) { Fabricate(Group::StateBoard::Supervisor.name.to_sym, group: groups(:be_board)) }

        it 'has layer and below read permission' do
          expect(role.permissions).to include(:layer_and_below_read)
        end

        context 'own group' do
          let(:group) { role.group }

          it 'may get himself' do
            is_expected.to include(role.person)
          end

          it 'may get people in his group' do
            other = Fabricate(Group::StateBoard::Member.name.to_sym, group: group)
            is_expected.to include(other.person)
          end

          it 'may get external people in his group' do
            other = Fabricate(Group::StateBoard::External.name.to_sym, group: group)
            is_expected.to include(other.person)
          end
        end

        context 'group in same layer' do
          let(:group) { groups(:be_agency) }

          it 'may get people' do
            other = Fabricate(Group::StateAgency::Leader.name.to_sym, group: group)
            is_expected.to include(other.person)
          end

          it 'may get external people' do
            other = Fabricate(Group::StateAgency::External.name.to_sym, group: group)
            is_expected.to include(other.person)
          end
        end

        context 'lower group' do
          let(:group) { groups(:bern) }

          it 'may get visible people' do
            other = Fabricate(Group::Flock::Leader.name.to_sym, group: group)
            is_expected.to include(other.person)
          end

          it 'may not get external people' do
            other = Fabricate(Group::Flock::External.name.to_sym, group: group)
            is_expected.not_to include(other.person)
          end
        end

        context 'child group' do
          let(:group) { groups(:asterix) }

          it 'may not get children' do
            other = Fabricate(Group::ChildGroup::Child.name.to_sym, group: group)
            is_expected.not_to include(other.person)
          end
        end

      end

      describe :group_full do
        let(:role) { Fabricate(Group::StateBoard::GroupAdmin.name.to_sym, group: groups(:be_board)) }

        it 'has group full permission' do
          expect(role.permissions).to include(:group_full)
        end

        context 'own group' do
          let(:group) { role.group }

          it 'may get himself' do
            is_expected.to include(role.person)
          end

          it 'may get people in his group' do
            other = Fabricate(Group::StateBoard::Member.name.to_sym, group: group)
            is_expected.to include(other.person)
          end

          it 'may get external people in his group' do
            other = Fabricate(Group::StateBoard::External.name.to_sym, group: group)
            is_expected.to include(other.person)
          end
        end

        context 'group in same layer' do
          let(:group) { groups(:be_agency) }

          it 'may not get people' do
            other = Fabricate(Group::StateAgency::Leader.name.to_sym, group: group)
            is_expected.not_to include(other.person)
          end

          it 'may not get external people' do
            other = Fabricate(Group::StateAgency::External.name.to_sym, group: group)
            is_expected.not_to include(other.person)
          end
        end

        context 'lower group' do
          let(:group) { groups(:bern) }

          it 'may not get visible people' do
            other = Fabricate(Group::Flock::Leader.name.to_sym, group: group)
            is_expected.not_to include(other.person)
          end
        end

      end

      describe :contact_data do
        let(:role) { Fabricate(Group::StateBoard::Member.name.to_sym, group: groups(:be_board)) }

        it 'has contact data permission' do
          expect(role.permissions).to include(:contact_data)
        end

        context 'own group' do
          let(:group) { role.group }

          it 'may get himself' do
            is_expected.to include(role.person)
          end

          it 'may get people in his group' do
            other = Fabricate(Group::StateBoard::Member.name.to_sym, group: group)
            is_expected.to include(other.person)
          end

          it 'may get external people in his group' do
            other = Fabricate(Group::StateBoard::External.name.to_sym, group: group)
            is_expected.to include(other.person)
          end
        end

        context 'group in same layer' do
          let(:group) { groups(:be_state_camp) }

          it 'may get people with contact data' do
            other = Fabricate(Group::StateWorkGroup::Leader.name.to_sym, group: group)
            is_expected.to include(other.person)
          end

          it 'may not get people without contact data' do
            other = Fabricate(Group::StateWorkGroup::Member.name.to_sym, group: group)
            is_expected.not_to include(other.person)
          end

          it 'may not get external people' do
            other = Fabricate(Group::StateWorkGroup::External.name.to_sym, group: group)
            is_expected.not_to include(other.person)
          end
        end

        context 'lower group' do
          let(:group) { groups(:bern) }

          it 'may get people with contact data' do
            other = Fabricate(Group::Flock::Leader.name.to_sym, group: group)
            is_expected.to include(other.person)
          end

          it 'may not get people without contact data' do
            other = Fabricate(Group::Flock::Guide.name.to_sym, group: group)
            is_expected.not_to include(other.person)
          end

          it 'may not get external people' do
            other = Fabricate(Group::Flock::External.name.to_sym, group: group)
            is_expected.not_to include(other.person)
          end
        end

      end


      describe :group_read do
        let(:role) { Fabricate(Group::StateWorkGroup::Member.name.to_sym, group: groups(:be_state_camp)) }

        it 'has only login permission' do
          expect(role.permissions).to eq([:group_read])
        end

        context 'own group' do
          let(:group) { role.group }

          it 'may get himself' do
            is_expected.to include(role.person)
          end

          it 'may get people in his group' do
            other = Fabricate(Group::StateWorkGroup::Leader.name.to_sym, group: group)
            is_expected.to include(other.person)
          end

          it 'may get external people in his group' do
            other = Fabricate(Group::StateWorkGroup::External.name.to_sym, group: group)
            is_expected.to include(other.person)
          end
        end

        context 'group in same layer' do
          let(:group) { groups(:be_board) }

          it 'may not get people with contact data' do
            other = Fabricate(Group::StateBoard::Leader.name.to_sym, group: group)
            is_expected.not_to include(other.person)
          end

          it 'may not get external people' do
            other = Fabricate(Group::StateBoard::External.name.to_sym, group: group)
            is_expected.not_to include(other.person)
          end
        end

        context 'lower group' do
          let(:group) { groups(:bern) }

          it 'may not get people with contact data' do
            other = Fabricate(Group::Flock::Leader.name.to_sym, group: group)
            is_expected.not_to include(other.person)
          end

          it 'may not get external people' do
            other = Fabricate(Group::Flock::External.name.to_sym, group: group)
            is_expected.not_to include(other.person)
          end
        end

      end

      describe :alumnus_group_below_read do
        let(:role) do
          Fabricate(Group::FederalAlumnusGroup::Leader.name, group: groups(:ch_ehemalige))
        end

        let(:group) { groups(:bern_ehemalige) }


        it 'may get alumni member' do
          other = Fabricate(Group::FlockAlumnusGroup::Member.name, group: group)
          is_expected.to include(other.person)
        end
      end


      describe 'no permissions' do
        let(:role) { Fabricate(Group::StateWorkGroup::External.name.to_sym, group: groups(:be_state_camp)) }

        it 'has no permissions' do
          expect(role.permissions).to eq([])
        end

        context 'own group' do
          let(:group) { role.group }

          if action == :index
            it 'may not get himself' do
              is_expected.not_to include(role.person)
            end
          else
            it 'may get himself' do
              is_expected.to include(role.person)
            end
          end

          it 'may not get people in his group' do
            other = Fabricate(Group::StateWorkGroup::Leader.name.to_sym, group: group)
            is_expected.not_to include(other.person)
          end

          it 'may not get external people in his group' do
            other = Fabricate(Group::StateWorkGroup::External.name.to_sym, group: group)
            is_expected.not_to include(other.person)
          end
        end

        context 'group in same layer' do
          let(:group) { groups(:be_board) }

          it 'may not get people with contact data' do
            other = Fabricate(Group::StateBoard::Leader.name.to_sym, group: group)
            is_expected.not_to include(other.person)
          end
        end

        context 'lower group' do
          let(:group) { groups(:bern) }

          it 'may not get people with contact data' do
            other = Fabricate(Group::Flock::Leader.name.to_sym, group: group)
            is_expected.not_to include(other.person)
          end
        end

      end

      describe :root do
        let(:user) { people(:root) }

        context 'every group' do
          let(:group) { groups(:federal_board) }

          it 'may get all people' do
            other = Fabricate(Group::FederalBoard::Member.name.to_sym, group: group)
            is_expected.to include(other.person)
          end

          it 'may get external people' do
            other = Fabricate(Group::FederalBoard::External.name.to_sym, group: group)
            is_expected.to include(other.person)
          end
        end

        if action == :global
          it 'may get herself' do
            is_expected.to include(user)
          end

          it 'may get people outside groups' do
            other = Fabricate(:person)
            is_expected.to include(other)
          end
        end

      end

    end
  end
end
