# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe Event::ListsController do

  before { sign_in(people(:top_leader)) }

  context 'BSV export' do
    render_views

    it 'POST#create' do
      get :courses, year: 2012, kind: 'bsv', format: :csv
      response.body.should be_present
    end
  end
end
