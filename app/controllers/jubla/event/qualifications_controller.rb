# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::Event::QualificationsController
  extend ActiveSupport::Concern

  included do
    alias_method_chain :update, :check
    alias_method_chain :destroy, :check
  end

  def update_with_check
    with_check { update_without_check }
  end

  def destroy_with_check
    with_check { destroy_without_check }
  end

  private

  def with_check
    if event.qualification_possible?
      yield
    else
      participation # load participation so it gets decorated
      render 'qualification'
    end
  end
end
