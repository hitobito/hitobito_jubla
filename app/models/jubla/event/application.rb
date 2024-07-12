#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::Event::Application
  extend ActiveSupport::Concern

  included do
    alias_method_chain :contact, :group_type
  end

  def contact_with_group_type
    event.application_contact.presence || contact_without_group_type
  end
end
