# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

%w(base filter abo migrator).each { |file| require_relative "convert_globals_support/#{file}" }

class ConvertGlobalsToSpecificRoles < ActiveRecord::Migration

  def up
    roles.each { |role| Migrator.new(role).perform }
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  def roles
    [Jubla::Role::GroupAdmin,
     Jubla::Role::DispatchAddress,
     Jubla::Role::External]
  end
end

