# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe CensusEvaluation::FederationController do

  let(:ch)   { groups(:ch) }
  let(:be)   { groups(:be) }
  let(:no)   { groups(:no) }
  let(:zh)   { Fabricate(Group::State.name, name: 'Zurich', parent: ch) }

  before do
    zh # create

    sign_in(people(:top_leader))
  end


  describe 'GET index' do
    before { allow(Date).to receive_messages(today: censuses(:two_o_12).finish_at) }

    before { get :index, params: { id: ch.id } }

    it 'assigns counts' do
      counts = assigns(:group_counts)
      expect(counts.keys).to match_array([be.id, no.id])
      expect(counts[be.id].total).to eq(19)
      expect(counts[no.id].total).to eq(9)
    end

    it 'assigns total' do
      expect(assigns(:total)).to be_kind_of(MemberCount)
    end

    it 'assigns sub groups' do
      expect(assigns(:sub_groups)).to eq([be, no, zh])
    end

    it 'assigns flocks' do
      expect(assigns(:flocks)).to eq({
        be.id => { confirmed: 2, total: 3 },
        no.id => { confirmed: 1, total: 2 },
        zh.id => { confirmed: 0, total: 0 },
      })
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

    it 'assigns year' do
      expect(assigns(:year)).to eq(Census.last.year)
    end
  end

end
