#  Copyright (c) 2012-2025, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require "spec_helper"

describe "Globalized input fields", js: true do
  let(:group) { groups(:ch) }

  before do
    sign_in(people(:top_leader))
    visit edit_group_path(group)
  end

  it "should show globalized field without translation option in single language wagon" do
    expect(page).to have_css("input[id^='group_privacy_policy_title']", count: 1, visible: false)
    expect(page).not_to have_css("button[data-action='globalized-fields#toggleFields']")

    fill_in "group_privacy_policy_title", with: "Some privacy policy title"
    expect(page).not_to have_content("Zusätzlich ausgefüllte Sprachen")

    click_button("Speichern")
    expect(page).to have_content("Gruppe #{group.name} wurde erfolgreich aktualisiert")
    expect(group.reload.privacy_policy_title_translations).to eql({de: "Some privacy policy title"}.stringify_keys)
  end
end
