# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

Rails.application.routes.draw do

  resources :censuses, only: [:new, :create]

  resources :event_camp_kinds, module: 'event', controller: 'camp/kinds'

  resources :groups do
    member do
      scope module: 'census_evaluation' do
        get 'census/federation' => 'federation#index'
        get 'census/state' => 'state#index'
        get 'census/flock' => 'flock#index'
        post 'census/state/remind' => 'state#remind'
      end

      get 'population' => 'population#index'
    end

    resources :events, only: [] do # do not redefine events actions, only add new ones
      collection do
        get 'camp' => 'events#index', type: 'Event::Camp'
      end
    end

    resources :event_course_conditions, module: 'event', controller: 'course/conditions'
    resource :member_counts, only: [:create, :edit, :update, :destroy]
  end

end
