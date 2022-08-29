# frozen_string_literal: true

#  Copyright (c) 2022, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe Events::Filter::Groups do
  let(:params) { { } }

  let(:scope) { Events::FilteredList.new(person, {}, {}).base_scope.distinct }

  subject(:filter) { described_class.new(person, params, {}, scope) }

  let(:sql) { filter.to_scope.to_sql }
  let(:where_condition) { sql.sub(/.*(WHERE.*)$/, '\1') }

  context 'as leader user' do
    let(:person) { people(:flock_leader) }
    let(:non_hierarchy_group_ids) { [groups(:bern).id, groups(:be).id] }
    let(:non_hierarchy_event_ids) { [events(:top_course), events(:camp)].map(&:id) }

    let(:params) { { filter: { group_ids: person.groups.pluck(:id) + non_hierarchy_group_ids } } }

    context 'generally, it' do
      it 'produces a scope that includes globally_visible' do
        expect(where_condition).to match('`events`.`globally_visible`')

        expect(where_condition).to include(
          "OR `events`.`id` IN (#{non_hierarchy_event_ids.join(', ')}) AND `events`.`globally_visible` = TRUE"
        )
      end

      context 'has assumptions' do
        it 'mentions events' do
          expect(sql).to match('events')
        end

        it 'there is a WHERE condition' do
          expect(where_condition).to match(/^WHERE/)
        end
      end
    end
  end

  context 'as non leader user' do
    let(:person) { people(:child) }

    context 'generally, it' do
      it 'produces a scope that does not include globally_visible' do
        expect(where_condition).to_not match('`events`.`globally_visible`')

        expect(where_condition).to_not match(
          /OR .*`events`.`globally_visible` = TRUE/
        )
      end
    end
  end
end
