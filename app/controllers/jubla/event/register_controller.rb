# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::Event::RegisterController
    
  extend ActiveSupport::Concern
    
  included do
    alias_method_chain :create_person, :role
  end
    
  def create_person_with_role
    if create_person_without_role
      role = external_role_class.new
      role.group = group
      role.person = person
      role.save!
      person.roles << role
      true
    end
  end

  def external_role_class
    "#{group.class.to_s}::External".constantize
  end
end
