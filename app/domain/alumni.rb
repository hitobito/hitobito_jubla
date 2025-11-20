# frozen_string_literal: true

#  Copyright (c) 2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.
#
module Alumni
  EXCLUDED_ROLE_TYPES = [
    Group::Root::Admin,
    Jubla::Role::External,
    Jubla::Role::DispatchAddress,
    Jubla::Role::Alumnus,
    Group::AlumnusGroup::Leader,
    Group::AlumnusGroup::GroupAdmin,
    Group::AlumnusGroup::Treasurer,
    Group::AlumnusGroup::Member,
    Group::AlumnusGroup::External,
    Group::AlumnusGroup::DispatchAddress,
    NejbRole
  ].freeze

  APPLICABLE_ROLE_TYPES = ::Role.all_types.reject do |role|
    Alumni::EXCLUDED_ROLE_TYPES.any? { |excluded| role < excluded }
  end
end
