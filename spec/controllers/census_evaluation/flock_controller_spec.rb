# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe CensusEvaluation::FlockController do

  let(:bern) { groups(:bern) }

  before { sign_in(people(:top_leader)) }

  describe 'GET total' do

    before { get :index, id: bern.id }

    it 'assigns counts' do
      expect(assigns(:group_counts)).to be_blank
    end

    it 'assigns total' do
      total = assigns(:total)
      expect(total).to be_kind_of(MemberCount)
      expect(total.total).to eq(12)
    end

    it 'assigns sub groups' do
      expect(assigns(:sub_groups)).to be_blank
    end

    it 'assigns details' do
      details = assigns(:details).to_a
      expect(details).to have(3).items
      expect(details[0].born_in).to eq(1985)
      expect(details[1].born_in).to eq(1988)
      expect(details[2].born_in).to eq(1997)
    end
  end

end
