# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module PopulationHelper

  BADGE_INVALID = '<span class="text-error">Angabe fehlt</span>'.html_safe

  def person_birthday_with_check(person)
    if person.birthday.blank?
      BADGE_INVALID
    else
      l(person.birthday)
    end
  end

  def person_gender_with_check(person)
    if person.gender.blank?
      BADGE_INVALID
    else
      person.gender_label
    end
  end

  def tab_population_label(group)
    label = 'Bestand'
    label << ' <span style="color: red;">!</span>' if check_approveable?(group)
    label.html_safe
  end

  def check_approveable?(group = @group)
    group.population_approveable? && can?(:create_member_counts, group)
  end

end
