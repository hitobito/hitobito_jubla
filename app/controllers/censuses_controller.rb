# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class CensusesController < CrudController

  self.permitted_attrs = [:year, :start_at, :finish_at]

  before_action :group

  after_create :send_invitation_mail

  decorates :group

  def create
    super(location: census_federation_group_path(Group.root))
  end

  private

  def send_invitation_mail
    CensusInvitationJob.new(@census).enqueue!
  end

  def group
    @group ||= Group.root
  end

end
