# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe CensusReminderJob do

  before do
    flock.roles.where(type: Group::Flock::Leader.sti_name).destroy_all
  end

  let(:flock) { groups(:bern) }
  let(:leaders) do
    all = []
    all << Fabricate(Group::Flock::Leader.name.to_sym, group: flock, person: Fabricate(:person, email: 'test1@example.com')).person
    all << Fabricate(Group::Flock::Leader.name.to_sym, group: flock, person: Fabricate(:person, email: 'test2@example.com')).person

    # empty email
    all << Fabricate(Group::Flock::Leader.name.to_sym, group: flock, person: Fabricate(:person, email: ' ')).person
    all
  end

  subject { CensusReminderJob.new(people(:top_leader), Census.current, flock) }


  describe '#recipients' do

    it 'contains all flock leaders with emails' do
      leaders

      # different roles
      Fabricate(Group::StateAgency::Leader.name.to_sym, group: groups(:be_agency))
      Fabricate(Group::ChildGroup::Leader.name.to_sym, group: groups(:asterix))
      Fabricate(Group::Flock::Guide.name.to_sym, group: flock)

      expect(subject.recipients).to match_array(leaders[0..1])
    end
  end

  describe '#perform' do
    it 'sends email if flock has leaders' do
      leaders
      expect { subject.perform }.to change { ActionMailer::Base.deliveries.size }.by(1)
    end

    it 'does not send email if flock has no leaders' do
      expect { subject.perform }.not_to change { ActionMailer::Base.deliveries.size }
    end

    it 'does not send email if leader has no email' do
      Fabricate(Group::Flock::Leader.name.to_sym, group: flock, person: Fabricate(:person, email: '  ')).person
      expect { subject.perform }.not_to change { ActionMailer::Base.deliveries.size }
    end

    it 'finds ast address' do
      leaders
      subject.perform
      expect(last_email.body).to match(/AST<br\/>3000 Bern/)
    end

    it 'sends only to leaders with email' do
      leaders
      subject.perform
      expect(last_email.to).to eq([leaders.first.email, leaders.second.email])
    end
  end

end
