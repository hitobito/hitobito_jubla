# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe PopulationController, type: :controller do

  render_views

  let(:be) { groups(:bern) }
  let(:ar) { groups(:ausserroden) }
  let(:dom) { Capybara::Node::Simple.new(response.body) }

  before { sign_in(people(:top_leader)) }

  describe 'GET index' do

    it 'does not show any approveable content if there is no current census' do
      get :index, params: { id: be.id }
      expect(dom.all('#content h2').count).to eq 4
      expect(dom).to have_no_selector('a', text: 'Bestand bestätigen')
      expect(dom).to have_no_selector('.alert.alert-info.approveable')
      expect(dom).to have_no_selector('.alert.alert-alert.approveable')
      expect(dom.find('a', text: 'Bestand')).to have_no_selector('span', text: '!')
    end

    it 'does show all approveable content if there is a current census' do
      get :index, params: { id: ar.id }
      expect(dom.all('#content h2').count).to eq 2
      expect(dom).to have_selector('a', text: 'Bestand bestätigen')
      expect(dom).to have_content('Bitte ergänze')
      expect(dom.all('a', text: 'Bestand').first).to have_selector('span', text: '!')
    end
  end
end
