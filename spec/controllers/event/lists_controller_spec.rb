# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'
require 'csv'

describe Event::ListsController do

  before { sign_in(user) }
  render_views

  let(:bsv) { CSV.parse(response.body, headers: true) }
  let(:kind) { event_kinds(:flock) }
  let(:user) { people(:top_leader) }
  let(:now) { Time.zone.now }
  subject { assigns(:camps).values.flatten }

  it 'GET#courses with kind csv' do
    get :bsv_export, params: { filter: { kinds: kind.id.to_s, bsv_since: '1.1.2012', bsv_until: '31.12.2012', states: ['closed'] } }
    expect(bsv).to have(0).item
  end

  describe 'GET all_camps' do
    let!(:current) do
      current = Fabricate(:camp)
      current.dates = [Fabricate(:event_date, start_at: now - 15.days, finish_at: now - 10.days),
                       Fabricate(:event_date, start_at: now - 5.days, finish_at: now + 5.days)]
      current
    end

    let!(:upcoming_in_range) do
      upcoming_in_range = Fabricate(:camp)
      upcoming_in_range.dates = [Fabricate(:event_date, start_at: now + 10.days, finish_at: nil),
                                 Fabricate(:event_date, start_at: now + 12.days, finish_at: nil)]
      upcoming_in_range
    end

    let!(:upcoming_outside_range) do
      upcoming_outside_range = Fabricate(:camp)
      upcoming_outside_range.dates = [Fabricate(:event_date, start_at: now + 50.days, finish_at: now + 55.days)]
      upcoming_outside_range
    end

    let!(:past) do
      past = Fabricate(:camp)
      past.dates = [Fabricate(:event_date, start_at: now - 5.days, finish_at: nil)]
      past
    end

    context 'with Group::Federation::ItSupport role' do
      let(:user) { Fabricate(Group::Federation::ItSupport.name.to_sym, group: groups(:ch)).person }

      it 'contains only current and upcoming camps' do
        get :all_camps
        is_expected.to eq([current, upcoming_in_range])
        is_expected.to_not include(upcoming_outside_range, past)
      end

      it 'via list_camps' do
        expect(get :camps).to redirect_to(list_all_camps_path)
      end
    end

    context 'with other role' do
      let(:user) { people(:child) }

      it 'is not allowed' do
        expect { get :all_camps }.to raise_error(CanCan::AccessDenied)
      end

      it 'is not allowed via list_camp' do
        expect { get :camps }.to raise_error(CanCan::AccessDenied)
      end
    end
  end

  describe 'GET state_camps' do
    let(:state) { groups(:be) }
    let(:flock_in_state) { groups(:thun) }
    let(:flock_outside_state) { groups(:ausserroden) }

    let!(:current) do
      current = Fabricate(:camp, groups: [flock_in_state])
      current.dates = [Fabricate(:event_date, start_at: now - 15.days, finish_at: now - 10.days),
                       Fabricate(:event_date, start_at: now - 5.days, finish_at: now + 5.days)]
      current
    end

    let!(:outside_state) do
      outside_state = Fabricate(:camp, groups: [flock_outside_state])
      outside_state.dates = [Fabricate(:event_date, start_at: now - 15.days, finish_at: now - 10.days),
                       Fabricate(:event_date, start_at: now - 5.days, finish_at: now + 5.days)]
      outside_state
    end

    let!(:upcoming_in_year) do
      upcoming_in_range = Fabricate(:camp, groups: [flock_in_state])
      upcoming_in_range.dates = [Fabricate(:event_date, start_at: now.end_of_year, finish_at: nil)]
      upcoming_in_range
    end

    let!(:upcoming_outside_year) do
      upcoming_outside_range = Fabricate(:camp, groups: [flock_in_state])
      upcoming_outside_range.dates = [Fabricate(:event_date, start_at: now + 1.year, finish_at: nil)]
      upcoming_outside_range
    end

    let!(:past_in_year) do
      past = Fabricate(:camp, groups: [flock_in_state])
      past.dates = [Fabricate(:event_date, start_at: now.beginning_of_year, finish_at: nil)]
      past
    end

    let!(:past_outside_year) do
      past = Fabricate(:camp, groups: [flock_in_state])
      past.dates = [Fabricate(:event_date, start_at: now - 1.year, finish_at: nil)]
      past
    end

    context 'with Group::State::Coach role' do
      let(:user) { Fabricate(Group::State::Coach.name.to_sym, group: state).person }

      it 'contains only current and upcoming camps' do
        get :state_camps, params: { group_id: state.id }
        is_expected.to contain_exactly(current, upcoming_in_year, past_in_year)
        is_expected.to_not include(upcoming_outside_year, past_outside_year, outside_state)
      end

      it 'via list_camps' do
        expect(get :camps).to redirect_to(list_state_camps_path(group_id: state.id))
      end
    end

    context 'with other role' do
      let(:user) { people(:child) }

      it 'is not allowed' do
        expect { get :all_camps }.to raise_error(CanCan::AccessDenied)
      end

      it 'is not allowed via list_camp' do
        expect { get :camps }.to raise_error(CanCan::AccessDenied)
      end
    end
  end
end
