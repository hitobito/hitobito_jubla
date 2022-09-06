# frozen_string_literal: true


module Jubla::Event::ListsController
  extend ActiveSupport::Concern

  included do
    skip_authorization_check only: :camps
  end

  def camps
    if can?(:list_all_camps, Event::Camp)
      redirect_to list_all_camps_path
    elsif can?(:list_state_camps, Event::Camp)
      role = current_user.roles.find do |role|
        EventAbility::STATE_CAMP_LIST_ROLES.any? { |t| role.is_a?(t) }
      end
      redirect_to list_state_camps_path(group_id: role.group_id)
    else
      raise(CanCan::AccessDenied)
    end
  end

  def all_camps
    authorize!(:list_all_camps, Event::Camp)

    @nav_left = 'camps'

    render_camp_list(all_upcoming_camps)
  end

  def state_camps
    authorize!(:list_state_camps, Event::Camp)

    @nav_left = 'camps'

    @group = Group::State.find(params[:group_id])
    render_camp_list(all_state_camps)
  end

  def all_upcoming_camps
    base_camp_query.upcoming.in_next(4.weeks)
  end

  private

  def render_camp_list(camps)
    respond_to do |format|
      format.html  { @camps = grouped(camps) }
      format.csv   { render_camp_csv(camps) }
    end
  end

  def render_camp_csv(camps)
    send_data Export::Tabular::Events::List.csv(camps), type: :csv
  end
  
  def all_state_camps
    base_camp_query.joins(:groups)
                   .where('groups.lft >= ? AND groups.rgt <= ?', @group.lft, @group.rgt)
                   .in_year(year)
  end

  def base_camp_query
    Event::Camp.includes(:groups)
               .list
  end
end
