# encoding: utf-8

#  Copyright (c) 2012-2017, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

require 'spec_helper'
describe Import::PersonImporter do

  let(:group) { groups(:ch_ehemalige) }
  let(:role_type) { Group::FederalAlumnusGroup::Member }
  let(:importer) do
    Import::PersonImporter.new(data, group, role_type)
  end

  subject { importer }

  context 'records failed imports' do
    let(:person) { people(:top_leader) }
    let(:data) do
      [{ first_name: person.first_name, last_name: person.last_name, email: person.email},
       { first_name: 'foobar', email: 'foo3@bar.net' }]
    end

    it 'creates only second record' do
      expect { importer.import }.to change(Person, :count).by(1)
    end

    context 'alumnus group member error' do
      before { importer.import }
      let(:error_message) { I18n.t('activerecord.errors.messages.cannot_import_alumnus',
                                   name: person.full_name) }

      its('errors.first') { should eq 'Zeile 1: Rollen ist nicht gültig' }
      its('errors.second') { should eq  error_message }
    end
  end
end

