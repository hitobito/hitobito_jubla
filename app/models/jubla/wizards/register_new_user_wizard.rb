#  Copyright (c) 2025, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::Wizards::RegisterNewUserWizard
  extend ActiveSupport::Concern

  delegate :person_attributes, to: :new_user_form
end
