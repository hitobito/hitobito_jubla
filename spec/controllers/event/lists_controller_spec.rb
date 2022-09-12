# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'
require 'csv'

describe Event::ListsController do

  before { sign_in(people(:top_leader)) }
  render_views

  let(:bsv) { CSV.parse(response.body, headers: true) }
  let(:kind) { event_kinds(:flock) }

  it 'GET#courses with kind csv' do
    get :bsv_export, params: { filter: { kinds: kind.id.to_s, bsv_since: '1.1.2012', bsv_until: '31.12.2012', states: ['closed'] } }
    expect(bsv).to have(0).item
  end
end
