#  Copyright (c) 2012-2026, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require "spec_helper"

describe Event::ParticipationContactDatasHelper, type: :helper do
  describe "#locked_contact_attr_options" do
    let(:person) { instance_double(Person, first_name: first_name, last_name: last_name) }
    let(:entry) { instance_double(Event::ParticipationContactData, person: person) }
    let(:first_name) { "Ada" }
    let(:last_name) { "Lovelace" }

    context "wenn first_name befüllt ist" do
      it "gibt readonly und hint zurück" do
        result = helper.locked_contact_attr_options(:first_name, entry)
        expect(result[:readonly]).to be true
        expect(result[:help_inline]).to be_present
      end
    end

    context "wenn last_name befüllt ist" do
      it "gibt readonly und hint zurück" do
        result = helper.locked_contact_attr_options(:last_name, entry)
        expect(result[:readonly]).to be true
        expect(result[:help_inline]).to be_present
      end
    end

    context "wenn first_name leer ist" do
      let(:first_name) { nil }

      it "gibt leere options zurück" do
        expect(helper.locked_contact_attr_options(:first_name, entry)).to eq({})
      end
    end

    context "für nicht gesperrte Felder (z.B. nickname)" do
      it "gibt leere options zurück" do
        expect(helper.locked_contact_attr_options(:nickname, entry)).to eq({})
      end
    end

    context "für Event::Guest (kein person-Objekt)" do
      let(:entry) { instance_double(Event::Guest) }

      it "gibt leere options zurück ohne Fehler" do
        expect(helper.locked_contact_attr_options(:first_name, entry)).to eq({})
      end
    end
  end
end
