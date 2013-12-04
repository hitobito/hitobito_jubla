# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::GroupsController
  extend ActiveSupport::Concern

  included do
    before_render_form :load_advisors
  end

  def load_advisors
    return unless entry.kind_of?(Group::Flock)
    @coaches = entry.available_coaches.only_public_data.order_by_name
    @advisors = entry.available_advisors.only_public_data.order_by_name
  end
end
