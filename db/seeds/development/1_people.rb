#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require Rails.root.join("db", "seeds", "support", "person_seeder")

class JublaPersonSeeder < PersonSeeder
  def amount(role_type)
    case role_type.name.demodulize
    when "Member", "External" then 5
    when "Child" then 10
    else 1
    end
  end

  def person_attributes(role_type)
    created_at = 0.upto(5 * 356).to_a.sample.days.ago
    super.merge(created_at: created_at) # make roles old_enough_to_soft_destroy
  end
end

puzzlers = ["Pascal Zumkehr",
  "Pascal Simon",
  "Pierre Fritsch",
  "Andreas Maierhofer",
  "Roland Studer",
  "Mathis Hofer",
  "Matthias Viehweger",
  "Janiss Binder",
  "Bruno Santschi"]
devs = {"Martin Zust" => "animation@jublaluzern.ch",
        "Roman Oester" => "roman.oester@jubla.ch"}

puzzlers.each do |puz|
  devs[puz] = "#{puz.split.last.downcase}@puzzle.ch"
end

seeder = JublaPersonSeeder.new
seeder.encrypted_password = BCrypt::Password.create("jub42la", cost: 1)

seeder.seed_all_roles

root = Group::FederalBoard.first
devs.each do |name, email|
  seeder.seed_developer(name, email, root, Group::FederalBoard::Member)
end

seeder.assign_role_to_root(root, Group::FederalBoard::Member)
