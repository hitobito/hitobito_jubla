# frozen_string_literal: true

#  Copyright (c) 2026, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

# Qualification adjustments for jubla#268.
# Example usage: rake qualis:limit_js_leiter_kindersport[5,true]
namespace :qualis do
  desc "Gives everybody with the Zusatz Scharleitung qualification the " \
       "Scharleitungskurs qualification (jubla#268)"
  task :copy_scharleitungskurs,
    [:source_kind_id, :target_kind_id, :dry_run] => :environment do |_task, args|
    require_relative "qualis/copy_scharleitungskurs"
    Qualis::CopyScharleitungskurs.new(source_kind_id: args[:source_kind_id],
      target_kind_id: args[:target_kind_id],
      dry_run: ActiveModel::Type::Boolean.new.cast(args[:dry_run]) || false).run
  end

  desc "Grants the Grundkurs qualification to everybody who attended a " \
       "Grundkurs (GK J+S or GK BSV) since 2002 (jubla#268)"
  task :grant_grundkurs,
    [:target_kind_id, :gk_js_event_kind_id, :gk_bsv_event_kind_id,
      :dry_run] => :environment do |_task, args|
    require_relative "qualis/grant_grundkurs"
    Qualis::GrantGrundkurs.new(target_kind_id: args[:target_kind_id],
      event_kind_ids: [args[:gk_js_event_kind_id], args[:gk_bsv_event_kind_id]],
      dry_run: ActiveModel::Type::Boolean.new.cast(args[:dry_run]) || false).run
  end

  desc "Expires the J+S Leiter*in LS/T Kindersport qualification at the end of 2026 (jubla#268)"
  task :limit_js_leiter_kindersport, [:kind_id, :dry_run] => :environment do |_task, args|
    require_relative "qualis/limit_js_leiter_kindersport"
    Qualis::LimitJsLeiterKindersport.new(kind_id: args[:kind_id],
      dry_run: ActiveModel::Type::Boolean.new.cast(args[:dry_run]) || false).run
  end
end
