# frozen_string_literal: true

#  Copyright (c) 2026, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

require "spec_helper"

describe Jubla::Export::Pdf::Participation::Confirmation do
  include PdfHelpers

  let(:pdf) { Export::Pdf::Document.new(page_size: "A4", page_layout: :portrait, margin: 2.cm).pdf }
  let(:contact) do
    Fabricate(:person, first_name: "Kurt", last_name: "Kontakt", nickname: "Kuku",
      email: "kurt@example.com", street: "Kontaktweg", housenumber: "3", zip_code: "3000",
      town: "Bern")
  end
  let(:agency) { groups(:be_agency) }
  let(:event) { events(:top_course) }
  let(:participation) { event_participations(:top_participant) }

  before do
    application = Fabricate(:event_application, priority_1: event, priority_2: nil)
    participation.update_columns(application_id: application.id)
    event.update_columns(contact_id: contact.id, remarks: nil, signature: false,
      signature_confirmation: false)
  end

  def hide_all_but(*visible_attrs)
    event.visible_contact_attributes = visible_attrs
    event.save!(validate: false)
  end

  def rendered_text
    described_class.new(pdf, participation.reload).render
    text_with_position.map(&:last).join(" ")
  end

  context "with application contact group" do
    before { event.update_columns(application_contact_id: agency.id) }

    it "renders the group regardless of the contact display options" do
      hide_all_but("phone_number")

      expect(rendered_text).to include("Anmeldung an", "AST", "3000 Bern")
      expect(rendered_text).not_to include("Kurt")
    end
  end

  context "without application contact group" do
    before { event.update_columns(application_contact_id: nil) }

    it "renders the contact person with nickname" do
      expect(rendered_text).to include(
        "Kurt Kontakt / Kuku, Kontaktweg 3, 3000 Bern oder kurt@example.com"
      )
    end

    it "omits the contact person attributes that are not visible" do
      hide_all_but("name")

      expect(rendered_text).to include("Anmeldung an Kurt Kontakt / Kuku")
      expect(rendered_text).not_to include("Kontaktweg", "kurt@example.com", "oder")
    end

    it "omits the section when no contact person attribute is visible" do
      hide_all_but("phone_number")

      expect(rendered_text).not_to include("Anmeldung an")
    end
  end
end
