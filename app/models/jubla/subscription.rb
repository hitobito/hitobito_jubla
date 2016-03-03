# encoding: utf-8

#  Copyright (c) 2012-2015, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::Subscription

  extend ActiveSupport::Concern

  included do
    alias_method_chain :possible_groups, :sisters
  end

  def possible_groups_with_sisters
    mailing_list.group.sister_groups_with_descendants
  end

end
