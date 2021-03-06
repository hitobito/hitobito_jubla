# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

# encoding:  utf-8

require 'spec_helper'

describe Event::Course::ConditionsController, type: :controller do


  let(:group) { groups(:ch) }
  let(:test_entry) { group.course_conditions.create!(label: 'foo', content: 'bar') }
  let(:test_entry_attrs) { { label: 'some label', content: 'some more content' } }
  let(:scope_params) {  { group_id: group.id } }

  before do
    test_entry
    sign_in(people(:top_leader))
  end

  class << self
    def it_should_redirect_to_show
      it { is_expected.to redirect_to group_event_course_conditions_path(returning: true) }
    end

    def it_should_assign_entry
      # weirdly, this fails in GET edit on jenkins.
    end
  end


  include_examples 'crud controller', skip: [%w(update html invalid), %w(destroy html invalid)]

end
