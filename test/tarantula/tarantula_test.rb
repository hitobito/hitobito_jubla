# encoding: utf-8

#  Copyright (c) 2012-2014, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'test_helper'
require 'relevance/tarantula'
require 'tarantula/tarantula_config'

class TarantulaTest < ActionDispatch::IntegrationTest
  # Load enough test data to ensure that there's a link to every page in your
  # application. Doing so allows Tarantula to follow those links and crawl
  # every page.  For many applications, you can load a decent data set by
  # loading all fixtures.

  reset_fixture_path File.expand_path('../../../spec/fixtures', __FILE__)

  include TarantulaConfig

  def test_tarantula_as_federal_board_member
    crawl_as(people(:top_leader))
  end

  def test_tarantula_as_flock_leader
    crawl_as(people(:flock_leader_bern))
  end

  def test_tarantula_as_child
    crawl_as(people(:child))
  end

  private

  def configure_urls_with_jubla(t, person)
    configure_urls_without_jubla(t, person)

    # The parent entry may already have been deleted, thus producing 404s.
    t.allow_404_for(/groups\/\d+\/member_counts$/)
  end
  alias_method_chain :configure_urls, :jubla

end
