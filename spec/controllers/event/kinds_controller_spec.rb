# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe Event::KindsController do

  before { sign_in(people(:top_leader)) }


  context 'custom attributes' do
    let(:kind) { assigns(:kind) }

    it 'POST#create' do
      post :create, params: {
                                  event_kind: { label: 'label',
                                                              kurs_id_fiver: 'some id',
                                                              vereinbarungs_id_fiver: 'some other id',
                                                              j_s_label: 'some other label' }
      }

      expect(kind.errors.full_messages).to eq []
      expect(kind.kurs_id_fiver).to eq 'some id'
      expect(kind.vereinbarungs_id_fiver).to eq 'some other id'
      expect(kind.j_s_label).to eq 'some other label'
    end

  end
end
