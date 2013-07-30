# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::EventDecorator
  extend ActiveSupport::Concern
  
  def multiple_contact_groups?
    possible_contact_groups.count > 1 ? true : false
  end
  
end
