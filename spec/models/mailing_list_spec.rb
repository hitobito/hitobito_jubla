# encoding: utf-8

#  Copyright (c) 2017, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.
# == Schema Information
#
# Table name: mailing_lists
#
#  id                   :integer          not null, primary key
#  name                 :string           not null
#  group_id             :integer          not null
#  description          :text
#  publisher            :string
#  mail_name            :string
#  additional_sender    :string
#  subscribable         :boolean          default(FALSE), not null
#  subscribers_may_post :boolean          default(FALSE), not null
#  anyone_may_post      :boolean          default(FALSE), not null
#

require 'spec_helper'

describe MailingList do

  let(:list)   { Fabricate(:mailing_list, group: layer) }
  let(:layer)  { groups(:ch) }
  let(:person) { Fabricate(:person) }

  describe 'exclusion by contact-preference' do
    before :each do
      create_subscription(person)
    end

    context 'list on federal level respect federal preference' do
      let(:layer) { groups(:ch) }

      it 'if not wanted' do
        person.update_attributes(contactable_by_federation: false)

        expect(list.subscribed?(person)).not_to be_truthy
      end

      it 'if wanted' do
        person.update_attributes(contactable_by_federation: true)

        expect(list.subscribed?(person)).to be_truthy
      end
    end

    context 'list on state level respect state preference' do
      let(:layer) { groups(:be) }

      it 'if not wanted' do
        person.update_attributes(contactable_by_state: false)

        expect(list.subscribed?(person)).not_to be_truthy
      end

      it 'if wanted' do
        person.update_attributes(contactable_by_state: true)

        expect(list.subscribed?(person)).to be_truthy
      end
    end

    context 'list on region level respect region preference' do
      let(:layer) { groups(:city) }

      it 'if not wanted' do
        person.update_attributes(contactable_by_region: false)

        expect(list.subscribed?(person)).not_to be_truthy
      end

      it 'if wanted' do
        person.update_attributes(contactable_by_region: true)

        expect(list.subscribed?(person)).to be_truthy
      end
    end
  end

  def create_subscription(subscriber, excluded = false, *role_types)
    sub = list.subscriptions.new
    sub.subscriber = subscriber
    sub.excluded = excluded
    sub.related_role_types = role_types.collect { |t| RelatedRoleType.new(role_type: t) }
    sub.save!
    sub
  end

end
