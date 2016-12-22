# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'
require_relative '../support/fabrication.rb'

describe EventAbility do

  let(:person)  { Fabricate(:person) }
  let(:event)   { Fabricate(:camp, coach_id: person.id).reload }

  subject { Ability.new(person.reload) }

  context 'is coach' do

    it 'may read participants when coaching' do
      is_expected.to be_able_to(:index_participations, event)
    end

    it 'may not read participants when not coaching' do
      event = Fabricate(:camp, coach_id: '')
      is_expected.not_to be_able_to(:index_participations, event)
    end
     
  end
end
