require 'spec_helper'

shared_examples 'sub_groups' do
  subject { evaluation.sub_groups.collect(&:name) }

  shared_examples 'sub_groups_examples' do

    context 'for current census' do
      it { is_expected.to eq current_census_groups.collect(&:name).sort }
    end

    context 'for past census' do
      before do
        # create another census after the current to make this a past one
        Census.create!(year: year + 1,
                       start_at: census.start_at + 1.year)
      end

      it { is_expected.to eq past_census_groups.collect(&:name).sort }
    end

    context 'for future census' do
      let(:year) { 2100 }
      before do
        Census.create!(year: 2100,
                       start_at: Date.new(2100, 1, 1))
      end

      it { is_expected.to eq future_census_groups.collect(&:name).sort }
    end
  end

  context 'when noop' do
    let(:current_census_groups) { subgroups }
    let(:past_census_groups)    { subgroups - [group_without_count] }
    let(:future_census_groups)  { subgroups }

    include_examples 'sub_groups_examples'
  end

  context 'when creating new group' do
    let!(:dummy) do
      d = Fabricate(group_to_delete.class.name.to_sym, parent: group, name: 'Dummy')
      group.reload # because lft, rgt changed
      d
    end
    let(:current_census_groups) { subgroups + [dummy] }
    let(:past_census_groups)    { subgroups - [group_without_count] } # dummy has no count
    let(:future_census_groups)  { subgroups + [dummy] }

    include_examples 'sub_groups_examples'
  end

  context 'when deleting group' do
    context 'deleting group only' do
      let(:current_census_groups) { subgroups }
      let(:past_census_groups)    { subgroups - [group_without_count] } # group included as it has count
      let(:future_census_groups)  { subgroups - [group_to_delete] }

      before { delete_group_and_children }

      include_examples 'sub_groups_examples'
    end

    context 'deleting group and member count' do
      let(:current_census_groups) { subgroups - [group_to_delete] }
      let(:past_census_groups)    { subgroups - [group_to_delete, group_without_count] } # dummy has no count
      let(:future_census_groups)  { subgroups - [group_to_delete] }

      before do
        delete_group_and_children
        delete_group_member_counts
      end

      include_examples 'sub_groups_examples'
    end
  end

  context 'when merging groups' do
    before do
      if group_to_delete.is_a?(Group::State)
        [group_to_delete, group_without_count].each { |g| g.events.destroy_all }
      end

      merger = Group::Merger.new(group_to_delete, group_without_count, 'Dummy')
      expect(merger.merge!).to be_truthy
      @dummy = merger.new_group
    end

    let(:current_census_groups) { subgroups - [group_without_count] + [@dummy] }
    let(:past_census_groups)    { subgroups - [group_without_count]  } # only groups with count
    let(:future_census_groups)  { subgroups - [group_to_delete, group_without_count] + [@dummy] }

    include_examples 'sub_groups_examples'
  end
end


describe CensusEvaluation do

  let(:ch)   { groups(:ch) }
  let(:be)   { groups(:be) }
  let(:no)   { groups(:no) }

  let(:census) { censuses(:two_o_12) }
  let(:year)   { census.year }
  let(:evaluation) { CensusEvaluation.new(year, group, sub_group_type) }


  context 'for bund' do
    let(:group) { ch }
    let(:zh)   { Fabricate(Group::State.name, name: 'Zurich', parent: ch) }
    let(:sub_group_type) { Group::State }

    before do
      zh
      ch.reload
    end

    it 'census is current census' do
      expect(evaluation).to be_census_current
    end

    it '#counts_by_sub_group' do
      counts = evaluation.counts_by_sub_group
      expect(counts.keys).to match_array([be.id, no.id])
      expect(counts[be.id].total).to eq(19)
      expect(counts[no.id].total).to eq(9)
    end

    it '#total' do
      expect(evaluation.total).to be_kind_of(MemberCount)
    end

    it '#details' do
      details = evaluation.details.to_a
      expect(details).to have(5).items

      expect(details[0].born_in).to eq(1984)
      expect(details[1].born_in).to eq(1985)
      expect(details[2].born_in).to eq(1988)
      expect(details[3].born_in).to eq(1997)
      expect(details[4].born_in).to eq(1999)
    end

    it '#sub_groups' do
      expect(evaluation.sub_groups).to eq([be, no, zh])
    end

    it_behaves_like 'sub_groups' do
      let(:subgroups)           { [be, no, zh] }
      let(:group_to_delete)     { be }
      let(:group_without_count) { zh }
    end
  end

  context 'for kantonalverband' do
    let(:group) { be }
    let(:sub_group_type) { Group::Flock }
    let(:bern) { groups(:bern) }
    let(:thun) { groups(:thun) }
    let(:muri) { groups(:muri) }

    it '#counts_by_sub_group' do
      counts = evaluation.counts_by_sub_group
      expect(counts.keys).to match_array([bern.id, thun.id])
      expect(counts[bern.id].total).to eq(12)
      expect(counts[thun.id].total).to eq(7)
    end

    it '#details' do
      details = evaluation.details.to_a
      expect(details).to have(5).items

      expect(details[0].born_in).to eq(1984)
      expect(details[1].born_in).to eq(1985)
      expect(details[2].born_in).to eq(1988)
      expect(details[3].born_in).to eq(1997)
      expect(details[4].born_in).to eq(1999)
    end

    it '#sub groups' do
      expect(evaluation.sub_groups).to eq([bern, muri, thun])
    end

    it_behaves_like 'sub_groups' do
      let(:subgroups)           { [bern, muri, thun] }
      let(:group_to_delete)     { bern }
      let(:group_without_count) { muri }

      context 'when moving group' do
        let(:target) { be }
        let(:innerroden)  { groups(:innerroden) }
        let(:ausserroden)  { groups(:ausserroden) }

        context 'before count' do
          before do
            expect(Group::Mover.new(innerroden).perform(target)).to be_truthy
            target.reload
          end

          context 'in new parent' do
            before { innerroden.member_counts.destroy_all }

            include_examples 'sub_groups_examples' do
              let(:current_census_groups) { subgroups + [innerroden] }
              let(:past_census_groups)    { subgroups - [group_without_count] }
              let(:future_census_groups)  { subgroups + [innerroden] }
            end
          end

          context 'in old parent' do
            let(:group) { groups(:no) }

            context '' do
              before { innerroden.member_counts.destroy_all }

              include_examples 'sub_groups_examples' do
                let(:current_census_groups) { [ausserroden] }
                let(:past_census_groups)    { [] } # empty for spec implementation reasons, tested in example below
                let(:future_census_groups)  { [ausserroden] }
              end
            end

            context 'for past census' do
              subject { evaluation.sub_groups.collect(&:name) }

              it 'contains moved group' do
                 Census.create!(year: census.year + 1,
                                start_at: census.start_at + 1.year)
                 is_expected.to eq [innerroden].collect(&:name).sort
              end
            end
          end

        end

        context 'after count' do
          before do
            expect(Group::Mover.new(innerroden).perform(target)).to be_truthy
            target.reload
          end

          context 'in new parent' do
            include_examples 'sub_groups_examples' do
              let(:current_census_groups) { subgroups }
              let(:past_census_groups)    { subgroups - [group_without_count] }
              let(:future_census_groups)  { subgroups + [innerroden] }
            end
          end

          context 'in old parent' do
            let(:group) { groups(:no) }

            include_examples 'sub_groups_examples' do
              let(:current_census_groups) { [ausserroden, innerroden] }
              let(:past_census_groups)    { [innerroden] }
              let(:future_census_groups)  { [ausserroden] }
            end
          end
        end
      end
    end
  end

  context 'for abteilung' do
    let(:group) { groups(:bern) }
    let(:sub_group_type) { nil }

    it '#counts' do
      expect(evaluation.counts_by_sub_group).to be_blank
    end

    it '#total' do
      total = evaluation.total
      expect(total).to be_kind_of(MemberCount)
      expect(total.total).to eq(12)
    end

    it '#sub groups' do
      expect(evaluation.sub_groups).to be_blank
    end

    it '#details' do
      details = evaluation.details.to_a
      expect(details).to have(3).items
      expect(details[0].born_in).to eq(1985)
      expect(details[1].born_in).to eq(1988)
      expect(details[2].born_in).to eq(1997)
    end
  end
end


def delete_group_member_counts
  field = "#{group_to_delete.class.model_name.element}_id"
  MemberCount.destroy_all(field => group_to_delete.id)
end

# Group#protect_if :children_without_deleted
# we first delete children, then group and validate return values
def delete_group_and_children(deleted_at = Time.zone.now)
  group_to_delete.update_column(:deleted_at, deleted_at)
  expect(group_to_delete).to be_deleted
end
