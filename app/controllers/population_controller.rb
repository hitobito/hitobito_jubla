# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class PopulationController < ApplicationController

  before_filter :authorize

  decorates :groups, :people, :group


  def index
    @groups = load_groups
    @people_by_group = load_people_by_group
    @people_data_complete = people_data_complete?
  end

  private

  def load_people(groups)
    Person.joins(:roles).
           where(roles: { group_id: groups.collect(&:id), deleted_at: nil }).
           members.
           preload_groups.
           uniq.
           order_by_role.
           order_by_name
  end

  def flock
    @group ||= Group::Flock.find(params[:id])
  end

  def load_groups
    flock.self_and_descendants.without_deleted.order_by_type(flock)
  end

  def load_people_by_group
    @groups.each_with_object({}) do |group, hash|
      hash[group] = PersonDecorator.decorate(load_people([group]))
    end
  end

  def people_data_complete?
    @people_by_group.values.flatten.all? do |p|
      p.birthday.present? && p.gender.present?
    end
  end

  def authorize
    authorize!(:approve_population, flock)
  end

end
