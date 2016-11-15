# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe EventAbility do
  let(:user) { participation.person }
  let(:event) { participation.event }
  let(:participation) { Fabricate(:event_participation, application: Fabricate(:jubla_event_application)) }

  before {  }

  subject { Ability.new(user.reload) }

  context :coach do
    context Event do
      it 'may read participants when coaching' do
        # TODO fabricate an Event::Camp::Role::Coach and assert read permissions
      end

      it 'may not read participants in other event' do
        other = Fabricate(:event, groups: [groups(:no)])
        is_expected.not_to be_able_to(:participations_read, other)
      end
    end
  end

end
