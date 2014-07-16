# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::EventAbility
  extend ActiveSupport::Concern

  include Jubla::EventConstraints

  included do
    on(Event) do
      general(:update, :destroy, :application_market, :qualify).
        at_least_one_group_not_deleted_and_not_closed_or_admin

      permission(:any).may(:index_participations_details).for_leaded_events
      permission(:group_full).may(:index_participations_details).in_same_group
      permission(:layer_full).may(:index_participations_details).in_same_layer_or_below
    end
  end

end
