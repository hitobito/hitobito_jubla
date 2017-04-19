# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe Export::Tabular::Events do

  let(:person) { Fabricate.build(:person_with_address_and_phone, j_s_number: 123) }
  let(:advisor) { Fabricate(:person_with_address_and_phone, j_s_number: 123) }
  let(:course) do
    Fabricate.build(:course, contact: person, state: :application_open, advisor_id: advisor.id)
  end
  let(:event) { Fabricate.build(:event, contact: person, state: :application_open) }
  let(:contactable_keys) do
    [:name, :address, :zip_code, :town, :email, :phone_numbers, :j_s_number]
  end

  context Export::Tabular::Events::List do

    context 'used labels' do
      let(:list) { Export::Tabular::Events::List.new(double('courses', map: [], first: nil)) }
      subject { list.attribute_labels }

      its(:keys) do
        should include(*[:advisor_name, :advisor_address, :advisor_zip_code, :advisor_town,
                         :advisor_email, :advisor_phone_numbers])
      end
      its(:values) do
        should include(*['LKB Name', 'LKB Adresse', 'LKB PLZ', 'LKB Ort', 'LKB Haupt-E-Mail',
                         'LKB Telefonnummern'])
      end
    end

    context 'translatable state' do
      let(:course) do
        Fabricate(:jubla_course, groups: [groups(:ch)], location: 'somewhere',
                  state: 'created')
      end
      let(:list)  { Export::Tabular::Events::List.new(Event::Course.where(id: course)) }
      let(:csv) { Export::Csv::Generator.new(list).call.split("\n")  }
      subject { csv.second.split(';') }

      # This tests the case where Event.possible_states is non-empty,
      # the case without predefined states is tested in the core.
      its([5]) { should eq 'Erstellt' }
    end
  end

  context Export::Tabular::Events::Row do
    let(:list) { OpenStruct.new(max_dates: 3, contactable_keys: contactable_keys) }

    context Event::Course do
      let(:row) { Export::Tabular::Events::Row.new(course, nil, {}, {}) }

      it { expect(row.fetch(:state)).to eq 'Offen zur Anmeldung' }
      it { expect(row.fetch(:contact_j_s_number)).to eq '123' }
      it { expect(row.fetch(:advisor_name)).to eq advisor.to_s }
      it { expect(row.fetch(:advisor_j_s_number)).to eq '123' } # varchar in db
    end

    # Regression for #10969, test export with simple Event too
    context Event do
      let(:row) { Export::Tabular::Events::Row.new(event, nil, {}, {}) }

      it { expect(row.fetch(:advisor_name)).to be_nil }
      it { expect(row.fetch(:advisor_j_s_number)).to be_nil }
    end
  end

end
