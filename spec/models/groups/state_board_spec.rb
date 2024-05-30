# frozen_string_literal: true

#  Copyright (c) 2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe Group::StateBoard do
  subject { groups(:be_board) }

  context 'nextcloud' do
    describe 'Supervisor' do
      let(:role_name) { 'Group::StateBoard::Supervisor' }
      let(:role) { Fabricate(role_name, group: subject) }
      let(:nextcloud_group) { role.nextcloud_group }

      it 'has a nextcloud-group' do
        expect(nextcloud_group).to be_present
      end

      it 'has a nextcloud-group with a displayName' do
        expect(nextcloud_group.displayName).to eql "Kalei - Stellenbegleitungen"
      end

      it 'has a nextcloud-group with a gid' do
        expect(nextcloud_group.gid).to eql "#{subject.id}_#{role.type}"
      end
    end
  end
end
