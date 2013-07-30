# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module JublaOst
  class Schartyp < Struct.new(:id)
    Schar = new(10)
    Relei = new(20)
    Kalei = new(30)
    Intern = new(100)
    Andere = new(80)
    Iast = new(110)
    Ehemalige = new(50)
  end
end