# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe Event::RegisterController do

  let(:event) { Fabricate(:event, groups: [groups(:be_board)], external_applications: true) }
  let(:group) { event.groups.first }

  describe 'PUT register' do
    it 'creates external role' do
      expect do
        put :register, group_id: group.id, id: event.id, person: { last_name: 'foo', email: 'foo@example.com' }
      end.to change { Group::StateBoard::External.where(group_id: group.id).count }.by(1)
    end
  end
end
