#  Copyright (c) 2012-2025, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

require "spec_helper"

describe Event::ApplicationMarketController, type: :controller  do
  render_views

  let(:be) { groups(:be) }
  let(:no) { groups(:no) }
  let(:dom) { Capybara::Node::Simple.new(response.body) }
  let(:course) { events(:top_course)}
  let(:person) { people(:top_leader) }

  before do
    Fabricate(Group::StateAgency::Leader.name.to_sym, group: groups(:be_agency), person:)
    sign_in(person)
  end

  it "renders index page" do
    get :index, params: {event_id: course.id, group_id: be.id}
    expect(dom).to have_css "h2", text: "Zugeteilte Teilnehmende"
  end

end
