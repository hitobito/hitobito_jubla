# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

# Kantonsvorstand
class Group::StateBoard < Group

  class Leader < Jubla::Role::Leader
    self.permissions = [:group_full, :layer_read, :contact_data]
  end

  class Member < Jubla::Role::Member
    self.permissions = [:group_read, :contact_data]
  end

  class President < Member
    self.used_attributes += [:employment_percent, :honorary]
  end

  # Stellenbegleitung
  class Supervisor < ::Role
    self.permissions = [:layer_read]
  end

  class GroupAdmin < Jubla::Role::GroupAdmin
  end

  class Alumnus < Jubla::Role::Alumnus
  end

  class External < Jubla::Role::External
  end

  class DispatchAddress < Jubla::Role::DispatchAddress
  end

  roles Leader, Member, Supervisor, President, GroupAdmin, Alumnus, External, DispatchAddress

end
