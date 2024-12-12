#  Copyright (c) 2012-2023, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

require "spec_helper"

describe Export::Pdf::Participation do
  include PdfHelpers

  let(:participation) { event_participations(:top_participant) }
  let!(:managers) do
    2.times.map do
      Fabricate(:person).tap do |manager|
        manager.phone_numbers.create(number: "+41 44 123 45 57", label: "Privat")
        participation.person.managers << manager
      end
    end
  end
  subject(:pdf) { described_class.render(participation) }

    it "renders with all managers" do
      expect(participation.person.managers).to contain_exactly(*managers)
      text = PDF::Inspector::Text.analyze(pdf).show_text.join(' ')
      expect(text).to include(PeopleManager.model_name.human(count: 1))
      managers.each do |manager|
        expect(text).to include("#{manager}: #{manager.email}, #{manager.phone_numbers.first.number}")
      end
    end
end
