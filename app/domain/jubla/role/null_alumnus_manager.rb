# frozen_string_literal: true

#  Copyright (c) 2024-2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

# Implementation of the NullObject-Pattern
#
# Mimics an AlumnusManager, but does nothing. Intended as a temporary drop-in
# to gradually phase out the previous alumnus-logic
module Jubla::Role
  class NullAlumnusManager
    def create = true

    def destroy = true
  end
end
