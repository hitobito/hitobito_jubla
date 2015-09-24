# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe Event::ListsController do

  before { sign_in(people(:top_leader)) }
  render_views

  let(:bsv) { CSV.parse(response.body, headers: true) }

  it 'GET#courses with kind csv' do
    get :bsv_export, bsv_export: { date_from: '1.1.2012', date_to: '31.12.2012' }
    expect(bsv).to have(1).item
  end
end
