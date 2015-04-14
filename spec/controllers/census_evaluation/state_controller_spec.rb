# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe CensusEvaluation::StateController do

  let(:ch)   { groups(:ch) }
  let(:be)   { groups(:be) }
  let(:bern) { groups(:bern) }
  let(:thun) { groups(:thun) }
  let(:muri) { groups(:muri) }

  before { sign_in(people(:top_leader)) }

  describe 'GET index' do
    before { get :index, id: be.id }

    it 'assigns counts' do
      counts = assigns(:group_counts)
      expect(counts.keys).to match_array([bern.id, thun.id])
      expect(counts[bern.id].total).to eq(12)
      expect(counts[thun.id].total).to eq(7)
    end

    it 'assigns total' do
      expect(assigns(:total)).to be_kind_of(MemberCount)
    end

    it 'assigns sub groups' do
      expect(assigns(:sub_groups)).to eq([bern, muri, thun])
    end

    it 'assigns details' do
      details = assigns(:details).to_a
      expect(details).to have(5).items

      expect(details[0].born_in).to eq(1984)
      expect(details[1].born_in).to eq(1985)
      expect(details[2].born_in).to eq(1988)
      expect(details[3].born_in).to eq(1997)
      expect(details[4].born_in).to eq(1999)
    end
  end

  describe 'POST remind' do
    it 'creates mail job' do
      expect { post :remind, id: be.id, flock_id: bern.id, format: :js }.to change { Delayed::Job.count }.by(1)
    end

    context '.js' do
      before { post :remind, id: be.id, flock_id: bern.id, format: :js }

      it 'renders update_flash' do
        is_expected.to render_template('census_evaluation/state/remind')
      end

      it 'sets flash messages' do
        expect(flash[:notice]).to match(/an Jungwacht Bern geschickt/)
      end
    end

    it 'redirects flock leaders' do
      sign_in(people(:flock_leader))
      expect do
        expect { post :remind, id: be.id, flock_id: bern.id, format: :js }.to raise_error(CanCan::AccessDenied)
      end.not_to change { Delayed::Job.count }
    end
  end

end
