# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

quali_kinds = QualificationKind.seed(:id,
 {id: 1,
  validity: 2},

 {id: 2,
  validity: 2},

 {id: 3,
  validity: 2},

 {id: 4,
  validity: nil},

 {id: 5,
  validity: 2},

 {id: 6,
  validity: 2}
)

QualificationKind::Translation.seed(:qualification_kind_id, :locale,
  {qualification_kind_id: quali_kinds[0].id,
   locale: 'de',
   label: 'Experte'},

  {qualification_kind_id: quali_kinds[1].id,
   locale: 'de',
   label: 'Gruppenleitung'},

  {qualification_kind_id: quali_kinds[2].id,
   locale: 'de',
   label: 'Scharleitung'},

  {qualification_kind_id: quali_kinds[3].id,
   locale: 'de',
   label: 'SLRG Brevet'},

  {qualification_kind_id: quali_kinds[4].id,
   locale: 'de',
   label: 'Lagerleitung'},

  {qualification_kind_id: quali_kinds[5].id,
   locale: 'de',
   label: 'Kursleitung'}
)

event_kinds = Event::Kind.seed(:id,
 {id: 1},

 {id: 2},

 {id: 3},

 {id: 4},

 {id: 5},

 {id: 6},

 {id: 7}
)

Event::Kind::Translation.seed(:event_kind_id, :locale,
  {event_kind_id: event_kinds[0].id,
   locale: 'de',
   label: 'Scharleitungskurs',
   short_name: 'SLK'},

  {event_kind_id: event_kinds[1].id,
   locale: 'de',
   label: 'Gruppenleitungskurs',
   short_name: 'GLK'},

  {event_kind_id: event_kinds[2].id,
   locale: 'de',
   label: 'Coachkurs',
   short_name: 'CK'},

  {event_kind_id: event_kinds[3].id,
   locale: 'de',
   label: 'Grundkurs',
   short_name: 'GK'},

  {event_kind_id: event_kinds[4].id,
   locale: 'de',
   label: 'Fortbildungskurs',
   short_name: 'FK'},

  {event_kind_id: event_kinds[5].id,
   locale: 'de',
   label: 'Vereinsadmin',
   short_name: 'VA'},

  {event_kind_id: event_kinds[6].id,
   locale: 'de',
   label: 'Einstufungstest',
   short_name: 'ET'},
)

Event::KindQualificationKind.seed(:id,
  {id: 1,
   event_kind_id: event_kinds[0].id,
   qualification_kind_id: quali_kinds[2].id,
   category: :qualification,
   role: :participant},

  {id: 2,
   event_kind_id: event_kinds[1].id,
   qualification_kind_id: quali_kinds[1].id,
   category: :qualification,
   role: :participant},

  {id: 3,
   event_kind_id: event_kinds[4].id,
   qualification_kind_id: quali_kinds[1].id,
   category: :prolongation,
   role: :participant},

  {id: 4,
   event_kind_id: event_kinds[4].id,
   qualification_kind_id: quali_kinds[2].id,
   category: :prolongation,
   role: :participant}
)
