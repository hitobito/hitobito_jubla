# frozen_string_literal: true

#  Copyright (c) 2012-2023, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.
#
module Jubla::FutureRole
  extend ActiveSupport::Concern

  included do
    skip_callback :save, :after, :set_person_origins
    skip_callback :destroy, :after, :set_person_origins

    skip_callback :create, :after, :alumnus_manager_destroy
    skip_callback :destroy, :after, :alumnus_manager_create

    skip_callback :create, :after, :alumnus_manager_create_for_alumnus
    skip_callback :destroy, :after, :alumnus_manager_destroy_for_alumnus
  end
end

