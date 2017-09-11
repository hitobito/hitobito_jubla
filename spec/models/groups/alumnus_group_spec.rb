# encoding: utf-8

#  Copyright (c) 2012-2017, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe Group::AlumnusGroup do

  let(:parent_group) { groups(:bern) }

  context '#destroy' do
    it 'destroy if not last alumnus group in layer' do
      Group::FlockAlumnusGroup.create(name: 'test_group', parent_id: parent_group.id)
      alumnus_group2 = Group::FlockAlumnusGroup.create(name: 'test_group2',
                                                       parent_id: parent_group.id)

      expect(alumnus_group2.destroy).not_to be false
      expect(Group.without_deleted.where(id: alumnus_group2.id)).not_to exist
    end

    it 'cannot destroy if last alumnus group in layer' do
      alumnus_group = Group::FlockAlumnusGroup.create(name: 'test_group',
                                                      parent_id: parent_group.id)

      expect(alumnus_group.destroy).to be false
      expect(Group.without_deleted.where(id: alumnus_group.id)).to exist
    end

  end
end
