# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.


require Rails.root.join('db', 'seeds', 'support', 'group_seeder')

srand(42)

Group::Root.seed_once(:name, name: 'JUBLA', parent_id: nil)
superstructure = Group::Root.first

seeder = GroupSeeder.new

ch = Group::Federation.first
unless ch.address.present?
  # avoid callbacks to prevent creating default groups twice
  ch.update_columns(seeder.group_attributes)
  ch.update_column(:parent_id, superstructure.id)

  ch.default_children.each do |child_class|
    child_class.first.update(seeder.group_attributes)
  end
end
Group::Nejb.seed_once(:name, name: 'Netzwerk Ehemalige Jungwacht Blauring', parent_id: superstructure.id)

Group::FederalWorkGroup.seed(:name, :parent_id,
                             name: 'AG Bundeslager',
                             parent_id: ch.id)

states = Group::State.seed(:name, :parent_id,
                           { name: 'Kanton Bern',
                             short_name: 'BE',
                             street: 'Klostergasse',
                             housenumber: 3,
                             zip_code: '3333',
                             town: 'Bern',
                             country: 'Schweiz',
                             email: 'bern@be.ch',
                             parent_id: ch.id },

                           { name: 'Kanton Zürich',
                             short_name: 'ZH',
                             street: 'Tellgasse',
                             housenumber: 3,
                             zip_code: '8888',
                             town: 'Zürich',
                             country: 'Schweiz',
                             email: 'zuerich@zh.ch',
                             parent_id: ch.id },

                           { name: 'Kanton Nordost',
                             short_name: 'NO',
                             street: 'Nordostgasse',
                             housenumber: 3,
                             zip_code: '9000',
                             town: 'Nordosthausen',
                             country: 'Schweiz',
                             email: 'nordost@nordost.ch',
                             parent_id: ch.id },

                           { name: 'Kanton Luzern',
                             short_name: 'LU',
                             street: 'Kramgasse',
                             housenumber: 3,
                             zip_code: '4000',
                             town: 'Luzern',
                             country: 'Schweiz',
                             email: 'luzern@lu.ch',
                             parent_id: ch.id },

                           { name: 'Kanton Schaffhausen',
                             short_name: 'SH',
                             street: 'Hauptstrasse',
                             housenumber: 3,
                             zip_code: '9500',
                             town: 'Stein',
                             country: 'Schweiz',
                             email: 'stein@jubla.ch',
                             parent_id: ch.id },

                             name: 'Kanton Unterwalden',
                             short_name: 'UW',
                             street: 'Hohle Gasse',
                             housenumber: 3,
                             zip_code: '4600',
                             town: 'Stans',
                             country: 'Schweiz',
                             email: 'uw@tell.ch',
                             parent_id: ch.id)

states.each do |s|
  seeder.seed_social_accounts(s)
  ast = s.children.where(type: 'Group::StateAgency').first
  ast.update(seeder.group_attributes)
end

Group::StateProfessionalGroup.seed(:name, :parent_id,
                                   { name: 'FG Sicherheit',
                                     parent_id: states[0].id },

                                   name: 'FG Security',
                                   parent_id: states[2].id)

Group::StateWorkGroup.seed(:name, :parent_id,
                           name: 'AG Kantonslager',
                           parent_id: states[0].id)

regions = Group::Region.seed(:name, :parent_id,
                             { name: 'Region Stadt',
                               parent_id: states[0].id }.merge(seeder.group_attributes),

                             { name: 'Region Oberland',
                               parent_id: states[0].id }.merge(seeder.group_attributes),

                             { name: 'Region Jura',
                               parent_id: states[0].id }.merge(seeder.group_attributes),

                             { name: 'Region Stadt',
                               parent_id: states[1].id }.merge(seeder.group_attributes),

                             { name: 'Region Oberland',
                               parent_id: states[1].id }.merge(seeder.group_attributes))

flocks = Group::Flock.seed(:name, :parent_id,
                           { name: 'Bern',
                             kind: 'Jungwacht',
                             parent_id: regions[0].id },

                           { name: 'Muri',
                             kind: 'Blauring',
                             parent_id: regions[0].id },

                           { name: 'Thun',
                             kind: 'Jungwacht',
                             parent_id: regions[1].id },

                           { name: 'Interlaken',
                             kind: 'Jubla',
                             parent_id: regions[1].id },

                           { name: 'Simmental',
                             kind: 'Jungwacht',
                             parent_id: regions[1].id },

                           { name: 'Biel',
                             kind: 'Blauring',
                             parent_id: regions[2].id },

                           { name: 'Chräis Chäib',
                             kind: 'Jubla',
                             parent_id: regions[3].id },

                           { name: 'Wiedikon',
                             kind: 'Jubla',
                             parent_id: regions[3].id },

                           { name: 'Innerroden',
                             kind: 'Blauring',
                             parent_id: states[2].id },

                           name: 'Ausserroden',
                           kind: 'Jungwacht',
                           parent_id: states[2].id)

flocks.each do |s|
  seeder.seed_social_accounts(s)
end

Group::ChildGroup.seed(:name, :parent_id,
                       { name: 'Asterix',
                         parent_id: flocks[0].id },

                       { name: 'Obelix',
                         parent_id: flocks[0].id },

                       { name: 'Idefix',
                         parent_id: flocks[0].id },

                       { name: 'Mickey',
                         parent_id: flocks[1].id },

                       { name: 'Minnie',
                         parent_id: flocks[2].id },

                       { name: 'Goofy',
                         parent_id: flocks[3].id },

                       { name: 'Donald',
                         parent_id: flocks[4].id },

                       { name: 'Gaston',
                         parent_id: flocks[5].id },

                       { name: 'Tim',
                         parent_id: flocks[6].id },

                       { name: 'Hadock',
                         parent_id: flocks[7].id },

                       { name: 'Batman',
                         parent_id: flocks[8].id },

                       { name: 'Robin',
                         parent_id: flocks[8].id },

                       name: 'Spiderman',
                       parent_id: flocks[9].id)

Group::SimpleGroup.seed(:name, :parent_id,
                        { name: 'Tschutter',
                          parent_id: flocks[0].id },

                        name: 'Angestellte',
                        parent_id: states[0].id)


Group.rebuild!
