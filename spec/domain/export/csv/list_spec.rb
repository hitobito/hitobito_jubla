# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

require 'spec_helper'
describe Export::Csv::Events::List do

  context 'to_csv' do
    context 'translatable state' do
      let(:course) do
        Fabricate(:jubla_course, groups: [groups(:ch)], location: 'somewhere',
                  state: 'created')
      end
      let(:list)  { Export::Csv::Events::List.new([course]) }
      let(:csv) { Export::Csv::Generator.new(list).csv.split("\n")  }
      subject { csv.second.split(';') }

      # This tests the case where Event.possible_states is non-empty,
      # the case without predefined states is tested in the core.
      its([4]) { should eq 'Erstellt' }
    end
  end
end
