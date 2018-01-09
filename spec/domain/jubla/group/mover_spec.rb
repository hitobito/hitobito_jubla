# encoding: utf-8

#  Copyright (c) 2012-2018, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

require 'spec_helper'

describe Group::Mover do
  let(:group) { groups(:be_ehemalige) }
  let(:candidates) { Group::Mover.new(group).candidates }

  it 'candidates are empty if group is last alumnus group' do
    expect(candidates).to be_empty
  end

  it 'candidates are present if parent has another alumnus group' do
    Group::StateAlumnusGroup.create!(name: 'other', parent: group.parent)
    expect(candidates).to be_present
  end

end
