# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe CensusEvaluation::FederationController, type: :controller do

  render_views

  let(:ch)   { groups(:ch) }
  let(:zh)   { Fabricate(Group::State.name, name: 'Zurich', parent: ch) }

  before do
    zh # create
    sign_in(people(:top_leader))
  end

  describe 'GET total' do
    context 'as admin' do
      before { get :index, params: { id: ch.id } }

      it 'renders correct templates' do
        is_expected.to render_template('index')
        is_expected.to render_template('_totals')
        is_expected.to render_template('_details')
      end
    end

    context 'as normal user' do
      before { sign_in(people(:flock_leader)) }
      before { get :index, params: { id: ch.id } }

      it 'renders correct templates' do
        is_expected.to render_template('index')
        is_expected.to render_template('_totals')
        is_expected.to render_template('_details')
      end
    end
  end

  describe 'GET csv' do

    context 'as admin' do
      before { get :index, params: { id: ch.id }, format: :csv }
      let(:csv) { CSV.parse(response.body, headers: true, col_sep: ';') }

      it 'redirectsafter job enqueue' do
        expect(response).to have_http_status(302)
      end
    end


    context 'as normal user' do
      before { sign_in(people(:flock_leader)) }

      it 'is rejected' do
        expect { get :index, params: { id: ch.id }, format: :csv }.to raise_error(CanCan::AccessDenied)
      end
    end
  end

end
