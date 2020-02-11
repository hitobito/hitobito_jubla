# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe Jubla::Export::Tabular::People::OriginatingGroups do

  let(:person) { people(:top_leader) }
  before { person.update(originating_flock: groups(:bern),
                         originating_state: groups(:be)) }

  context Export::Tabular::People::PersonRow do
    let(:row) { Export::Tabular::People::PersonRow.new(person.reload) }

    it 'includes originating flock and state name' do
      expect(row.originating_flock_id).to eq 'Jungwacht Bern'
      expect(row.originating_state_id).to eq 'Kanton Bern'
    end
  end

  context Export::Tabular::People::ParticipationRow do
    let(:row) { Export::Tabular::People::ParticipationRow.new(participation) }
    let(:participation) { Fabricate(:event_participation, person: person) }

    it 'includes originating flock and state name' do
      expect(row.originating_flock_id).to eq 'Jungwacht Bern'
      expect(row.originating_state_id).to eq 'Kanton Bern'
    end
  end

end
