# encoding: utf-8
# == Schema Information
#
# Table name: member_counts
#
#  id        :integer          not null, primary key
#  state_id  :integer          not null
#  flock_id  :integer          not null
#  year      :integer          not null
#  born_in   :integer
#  leader_f  :integer
#  leader_m  :integer
#  child_f   :integer
#  child_m   :integer
#  region_id :integer
#

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

Fabricator(:member_count) do
  year { 2012 }
end
