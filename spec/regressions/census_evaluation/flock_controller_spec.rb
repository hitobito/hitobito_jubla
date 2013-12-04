# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe CensusEvaluation::FlockController, type: :controller do

  render_views

  let(:ch)   { groups(:ch) }
  let(:be)   { groups(:be) }
  let(:bern) { groups(:bern) }

  before { sign_in(people(:top_leader)) }

  describe 'GET total' do
    before { get :index, id: bern.id }

    it 'renders correct templates' do
      should render_template('index')
      should_not render_template('_totals')
      should render_template('_details')
    end
  end

end
