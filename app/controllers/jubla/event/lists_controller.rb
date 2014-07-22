# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::Event::ListsController
  extend ActiveSupport::Concern

  included do
    alias_method_chain :render_courses_csv, :bsv
  end

  def render_courses_csv_with_bsv(courses)
    if params[:kind] == 'bsv'
      send_data Event::Course::BsvInfo::List.export(courses)
    else
      render_courses_csv_without_bsv(courses)
    end
  end
end

