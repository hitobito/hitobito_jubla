# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe Census do
  
  describe '.last' do
    subject { Census.last }
    
    it { should == censuses(:two_o_12) }
  end
  
  describe '.current' do
    subject { Census.current }
    
    it { should == censuses(:two_o_12) }
  end
end
