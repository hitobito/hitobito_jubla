require 'spec_helper'

describe Jubla::Export::Csv::People::OriginatingGroups do

  let(:person) { people(:top_leader) }
  before { person.update_attributes(originating_flock: groups(:bern),
                                    originating_state: groups(:be)) }

  context Export::Csv::People::PersonRow do
    let(:row) { Export::Csv::People::PersonRow.new(person.reload) }

    it 'includes originating flock and state name' do
      row.originating_flock_id.should eq 'Jungwacht Bern'
      row.originating_state_id.should eq 'Kanton Bern'
    end
  end

  context Export::Csv::People::ParticipationRow do
    let(:row) { Export::Csv::People::ParticipationRow.new(participation) }
    let(:participation) { Fabricate(:event_participation, person: person) }

    it 'includes originating flock and state name' do
      row.originating_flock_id.should eq 'Jungwacht Bern'
      row.originating_state_id.should eq 'Kanton Bern'
    end
  end

end
