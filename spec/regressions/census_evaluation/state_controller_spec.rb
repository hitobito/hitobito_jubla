# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe CensusEvaluation::StateController, type: :controller do

  render_views

  let(:ch)   { groups(:ch) }
  let(:be)   { groups(:be) }
  let(:bern) { groups(:bern) }
  let(:thun) { groups(:thun) }

  before { sign_in(people(:top_leader)) }

  describe 'GET total' do
    before { get :index, params: { id: be.id } }

    it 'renders correct templates' do
      is_expected.to render_template('index')
      is_expected.to render_template('_totals')
      is_expected.to render_template('_details')
    end
  end

end
