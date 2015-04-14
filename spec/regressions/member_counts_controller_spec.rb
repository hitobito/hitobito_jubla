# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe MemberCountsController, type: :controller do

  render_views

  let(:flock) { groups(:bern) }

  before { sign_in(people(:top_leader)) }

  describe 'GET edit' do
    before { get :edit, group_id: flock.id, year: 2012 }

    it 'should render template' do
      is_expected.to render_template('edit')
    end
  end

end
