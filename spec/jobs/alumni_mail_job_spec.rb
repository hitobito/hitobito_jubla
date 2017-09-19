# encoding: utf-8

#  Copyright (c) 2012-2017, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe AlumniMailJob do

  describe '#perform' do
    it 'sends flock email if there are only Alumnus::Member roles left' do
      person = Fabricate(:person, email: 'test1@example.com')
      group = groups(:bern) #Flock

      expect(AlumniMailer).to receive(:new_member_flock).with(person).and_call_original
      expect { AlumniMailJob.new(group.id, person.id).perform }.to change { ActionMailer::Base.deliveries.size }.by(1)
    end

    it 'sends email if there are only Alumnus::Member roles left' do
      person = Fabricate(:person, email: 'test1@example.com')
      group = groups(:city) #No Flock

      expect(AlumniMailer).to receive(:new_member).with(person).and_call_original
      expect { AlumniMailJob.new(group.id, person.id).perform }.to change { ActionMailer::Base.deliveries.size }.by(1)
    end

    it 'does not send email if there are other roles left' do
      person = people(:top_leader)
      group = person.groups.first

      expect(AlumniMailer).not_to receive(:new_member_flock).and_call_original
      expect(AlumniMailer).not_to receive(:new_member).and_call_original
      expect { AlumniMailJob.new(group.id, person.id).perform }.to change { ActionMailer::Base.deliveries.size }.by(0)
    end
  end

end
