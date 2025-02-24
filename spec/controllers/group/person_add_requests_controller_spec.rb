#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require "spec_helper"

describe Group::PersonAddRequestsController do
  before { sign_in(people(:top_leader)) }

  describe "#POST activate" do
    it "raises" do
      expect do
        post :activate, params: { group_id: groups(:ch).id }
      end.to raise_error "shall never get called with jubla wagon"
    end
  end

  describe "#DELETE deactivate" do
    it "raises" do
      expect do
        delete :deactivate, params: { group_id: groups(:ch).id }
      end.to raise_error "shall never get called with jubla wagon"
    end
  end
end