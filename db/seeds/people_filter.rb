# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

filters = PeopleFilter.seed(:group_type, :name,
 {name: 'Scharleiter',
  group_type: 'Group::State'},
  
 {name: 'Präses',
  group_type: 'Group::State'},
  
 {name: 'Scharleiter',
  group_type: 'Group::Region'},
  
 {name: 'Präses',
  group_type: 'Group::Region'}
)

RelatedRoleType.seed_once(:relation_id, :relation_type, :role_type,
 {relation_id: filters[0].id,
  relation_type: PeopleFilter.sti_name,
  role_type: 'Group::Flock::Leader'},
  
 {relation_id: filters[1].id,
  relation_type: PeopleFilter.sti_name,
  role_type: 'Group::Flock::President'},
  
 {relation_id: filters[2].id,
  relation_type: PeopleFilter.sti_name,
  role_type: 'Group::Flock::Leader'},
  
 {relation_id: filters[3].id,
  relation_type: PeopleFilter.sti_name,
  role_type: 'Group::Flock::President'},
)