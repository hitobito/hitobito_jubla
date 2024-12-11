# encoding: utf-8

#  Copyright (c) 2012-2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe AlumniMailJob do

  describe '#perform' do
    it 'sends flock email if there are only Alumnus::Member or ::Alumnus roles left' do
      group = groups(:bern)
      person = Fabricate(Group::FlockAlumnusGroup::Member.sti_name.to_sym, group: group.alumnus_group).person
      person = Fabricate(Group::Flock::Alumnus.sti_name.to_sym, group: group).person

      expect(AlumniMailer).to receive(:new_member_flock).with(person).and_call_original
      expect { AlumniMailJob.new(group.id, person.id).perform }.to change { ActionMailer::Base.deliveries.size }.by(1)
    end

    it 'sends flock email if there are only Alumnus::Member roles left' do
      group = groups(:bern)
      person = Fabricate(Group::FlockAlumnusGroup::Member.sti_name.to_sym, group: group.alumnus_group).person

      expect(AlumniMailer).to receive(:new_member_flock).with(person).and_call_original
      expect { AlumniMailJob.new(group.id, person.id).perform }.to change { ActionMailer::Base.deliveries.size }.by(1)
    end

    it 'sends email if there are only Alumnus::Member roles left' do
      group = groups(:city)
      person = Fabricate(Group::RegionalAlumnusGroup::Member.sti_name.to_sym, group: group.alumnus_group).person

      expect(AlumniMailer).to receive(:new_member).with(person).and_call_original
      expect { AlumniMailJob.new(group.id, person.id).perform }.to change { ActionMailer::Base.deliveries.size }.by(1)
    end

    it 'does not send flock email if there are other roles in the current flock-layer left' do
      group = groups(:bern)
      person = Fabricate(Group::Flock::Leader.sti_name.to_sym, group: group).person

      expect(AlumniMailer).not_to receive(:new_member_flock).and_call_original
      expect(AlumniMailer).not_to receive(:new_member).and_call_original
      expect { AlumniMailJob.new(group.id, person.id).perform }.to change { ActionMailer::Base.deliveries.size }.by(0)
    end

    it 'sends flock email if there are other roles in other layers' do
      group = groups(:bern)
      other_group = groups(:muri)

      role_class = Group::Flock::Leader.sti_name.to_sym

      person = Fabricate(role_class, group: other_group).person

      expect(AlumniMailer).to receive(:new_member_flock).with(person).and_call_original
      expect { AlumniMailJob.new(group.id, person.id).perform }.to change { ActionMailer::Base.deliveries.size }.by(1)
    end
  end

end
