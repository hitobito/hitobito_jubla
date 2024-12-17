#  Copyright (c) 2012-2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class AlumniMailer < ApplicationMailer
  NEW_MEMBER_FLOCK = "new_member_flock".freeze

  def new_member_flock(recipient)
    custom_content_mail(recipient.email, NEW_MEMBER_FLOCK, mail_values(recipient))
  end

  private

  def mail_values(recipient)
    {
      "recipient-name" => recipient.greeting_name,
      "recipient-profile-url" => person_url(recipient)
    }
  end
end
