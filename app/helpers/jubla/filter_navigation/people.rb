# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::FilterNavigation::People
  
  extend ActiveSupport::Concern
  
  included do
    FilterNavigation::People::PREDEFINED_FILTERS << 'Ehemalige'
    
    alias_method_chain :init_items, :alumni
  end
  
  def init_items_with_alumni
    init_items_without_alumni
    
    if can?(:index_full_people, group) || can?(:index_local_people, group)
      item('Ehemalige',
           filter_path(role_types: group.role_types.select(&:alumnus?).map(&:sti_name),
                       name: 'Ehemalige'))
    end
  end
end
