# frozen_string_literal: true

#  Copyright (c) 2024-2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

# Superclass for Groups of the NEJB branch of Jubla
class NejbGroup < Group
  # define nejb/global children
  children Group::NejbSimpleGroup
end
