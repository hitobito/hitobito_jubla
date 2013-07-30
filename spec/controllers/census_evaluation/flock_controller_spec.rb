# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe CensusEvaluation::FlockController do
  
  let(:ch)   { groups(:ch) }
  let(:be)   { groups(:be) }
  let(:bern) { groups(:bern) }

  
  before { sign_in(people(:top_leader)) }
  
  
  describe 'GET total' do
    
    before { get :index, id: bern.id }
    
    it "assigns counts" do
      assigns(:group_counts).should be_blank
    end
    
    it "assigns total" do
      total = assigns(:total)
      total.should be_kind_of(MemberCount)
      total.total.should == 12
    end
    
    it "assigns sub groups" do
      assigns(:sub_groups).should be_blank
    end
    
    it "assigns details" do
      details = assigns(:details).to_a
      details.should have(3).items
      details[0].born_in.should == 1985
      details[1].born_in.should == 1988
      details[2].born_in.should == 1997
    end
  end
  
end
