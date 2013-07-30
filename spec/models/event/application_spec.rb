# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe Jubla::Event::Application do

  let(:course) { Fabricate(:jubla_course, groups: [group]) }
  let(:date)   {{ label: 'foo', start_at_date: Date.today, finish_at_date: Date.today }}
  
  subject do
    Fabricate(:event_participation, event: course, application: Fabricate(:jubla_event_application)).application
  end


  context "state" do
    let(:group)  { groups(:be) }
    
    its(:contact) { should == groups(:be_agency)}
  end
  
  context "federation" do
    let(:group)  { groups(:ch) }
    
    its(:contact) { should == groups(:federal_board)}
  end
end
