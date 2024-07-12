# frozen_string_literal: true

#  Copyright (c) 2012-2017, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::Event::QualificationsController
  extend ActiveSupport::Concern

  included do
    alias_method_chain :update, :check
  end

  def update_with_check
    if event.qualification_possible?
      update_without_check
    else
      redirect_to group_event_qualifications_path(group, event)
    end
  end
end
