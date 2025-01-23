# frozen_string_literal: true

#  Copyright (c) 2025, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require "spec_helper"

describe Wizards::RegisterNewUserWizard do
  let(:params) { {} }
  let(:role_type) { Group::Flock::External }
  let(:group) { groups(:thun) }

  subject(:wizard) do
    described_class.new(group: group, **params).tap { |w| w.step_at(0) }
  end

  subject(:new_user_form) { wizard.new_user_form }

  context "with self_wizard_role_type on group" do
    before { group.update!(self_registration_role_type: role_type) }

    describe "validations" do
      it "is invalid if attributes are not present" do
        expect(wizard).not_to be_valid
        expect(new_user_form.errors).to have(3).item
        expect(new_user_form.errors[:first_name][0]).to eq "muss ausgefüllt werden"
        expect(new_user_form.errors[:last_name][0]).to eq "muss ausgefüllt werden"
        expect(new_user_form.errors[:email][0]).to eq "muss ausgefüllt werden"
      end

      it "is valid if required attributes are present" do
        params[:new_user_form] = {first_name: "test", last_name: "test", email: "tester@example.com"}
        expect(wizard).to be_valid
      end

      it "is invalid if phone number is invalid" do
        params[:new_user_form] = {first_name: "test", last_name: "test", email: "tester@example.com", phone_number: "1234"}
        expect(wizard).not_to be_valid
        expect(new_user_form.errors).to have(1).item
        expect(new_user_form.errors[:phone_number][0]).to eq "ist nicht gültig"
      end
    end

    describe "#save!" do
      let(:person) { Person.find_by(first_name: "test") }

      it "updates all person fields" do
        params[:new_user_form] = {
          first_name: "test",
          last_name: "dummy",
          address_care_of: "",
          street: "Bergstrasse",
          housenumber: "41",
          postbox: "3",
          zip_code: "3000",
          town: "Bern",
          email: "test@example.com",
          privacy_policy_accepted: true
        }
        freeze_time
        wizard.save!
        expect(person.privacy_policy_accepted_at).to eq Time.zone.now
        expect(person.last_name).to eq "dummy"
        expect(person.street).to eq "Bergstrasse"
        expect(person.housenumber).to eq "41"
        expect(person.postbox).to eq "3"
        expect(person.zip_code).to eq "3000"
        expect(person.town).to eq "Bern"
        expect(person.email).to eq "test@example.com"
      end

      it "sets non-public phone number with correct label" do
        params[:new_user_form] = {
          first_name: "test",
          last_name: "dummy",
          phone_number: "0781234567",
          email: "test@example.com",
          privacy_policy_accepted: true
        }
        wizard.save!
        expect(person.phone_numbers).to have(1).item
        number = person.phone_numbers.first
        expect(number.label).to eq "Privat"
        expect(number.number).to eq "+41 78 123 45 67"
        expect(number.public).to eq false
      end
    end
  end
end
