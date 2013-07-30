# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.


Census.seed(:year, 
  {year: 2011,
   start_at: Date.new(2011,8,1),
   finish_at: Date.new(2011,10,31)}
)

unless MemberCount.exists?
  Group::Flock.find_each do |flock|
    MemberCounter.new(2011, flock).count!
  end
end