# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

quali_kinds = QualificationKind.seed(:label,
 {label: 'Experte',
  validity: 2},

 {label: 'Gruppenleitung',
  validity: 2},

 {label: 'Scharleitung',
  validity: 2},

 {label: 'SLRG Brevet',
  validity: nil},

 {label: 'Lagerleitung',
  validity: 2},

 {label: 'Kursleitung',
  validity: 2}
)

Event::Kind.seed(:short_name,
 {label: 'Scharleiterkurs',
  short_name: 'SLK',
  qualification_kind_ids: [quali_kinds[2].id]},

 {label: 'Gruppenleiterkurs',
  short_name: 'GLK',
  qualification_kind_ids: [quali_kinds[1].id]},

 {label: 'Coachkurs',
  short_name: 'CK'},

 {label: 'Grundkurs',
  short_name: 'GK'},

 {label: 'Fortbildungskurs',
  short_name: 'FK'},

 {label: 'Vereinsadmin',
  short_name: 'VA'},

 {label: 'Einstufungstest',
  short_name: 'ET'}
)
