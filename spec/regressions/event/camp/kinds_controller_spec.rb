# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

# encoding:  utf-8

require 'spec_helper'

describe Event::Camp::KindsController, type: :controller do

  class << self
    def it_should_redirect_to_show
      it { should redirect_to event_camp_kinds_path(returning: true) }
    end
  end

  let(:test_entry) { event_camp_kinds(:house_kids) }
  let(:test_entry_attrs) { { label: 'The ultimate summer camp' } }

  before { sign_in(people(:top_leader)) }

  include_examples 'crud controller', skip: [%w(show)]


  describe_action :get, :index do
    it 'main menu admin is active' do
      dom = Capybara::Node::Simple.new(response.body)
      item = dom.find('body nav ul.nav li', text: 'Admin')
      item[:class].should == 'active'
    end
  end

end
