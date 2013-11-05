# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class CensusMailer < ActionMailer::Base

  CONTENT_INVITATION = 'census_invitation'
  CONTENT_REMINDER   = 'census_reminder'

  helper StandardHelper

  def reminder(sender, census, recipients, flock, state_agency)
    content = CustomContent.get(CONTENT_REMINDER)
    values = {
      'due-date'        => due_date(census),
      'recipient-names' => recipients.collect(&:first_name).join(', '),
      'contact-address' => contact_address(state_agency),
      'census-url'      => "<a href=\"#{census_url(flock)}\">#{census_url(flock)}</a>"
    }

    mail to: recipients.collect(&:email),
         from: sender,
         subject: content.subject do |format|
      format.html { render text: content.body_with_values(values) }
    end
  end

  def invitation(census, recipients)
    content = CustomContent.get(CONTENT_INVITATION)
    values = { 'due-date' => due_date(census) }

    mail to: Settings.email.mass_recipient,
         bcc: recipients,
         subject: content.subject do |format|
      format.html { render text: content.body_with_values(values) }
    end
  end

  private

  def due_date(census)
    I18n.l(census.finish_at)
  end

  def census_url(flock)
    population_group_url(flock)
  end

  def contact_address(group)
    return '' if group.nil?

    address = [group.to_s]
    address << group.address.to_s.gsub("\n", "<br/>").presence
    address << [group.zip_code, group.town].compact.join(" ").presence
    address << group.phone_numbers.where(public: true).collect(&:to_s).join("<br/>").presence
    address << group.email
    address.compact.join("<br/>")
  end
end