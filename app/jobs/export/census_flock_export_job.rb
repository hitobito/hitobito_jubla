#  Copyright (c) 2023, Cevi Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

class Export::CensusFlockExportJob < Export::ExportBaseJob
  self.parameters = PARAMETERS + [:year]

  # options include:
  #   type       of export e.g. federation, state
  #   filename   of the created file
  #   group_id   of the parent-group considered for exporting, may be nil
  def initialize(format, user_id, year, options)
    super(format, user_id, options)
    @year = year
  end

  def entries
    case @options[:type]
    when "federation" then Export::Tabular::CensusFlockFederationList.new(@year).entries
    when "state" then Export::Tabular::CensusFlockStateList.new(@year, @options[:group_id]).entries
    else Export::Tabular::CensusFlockList.new(@year, @options[:group_id]).entries
    end
  end

  def exporter
    case @options[:type]
    when "federation" then Export::Tabular::CensusFlockFederation
    when "state" then Export::Tabular::CensusFlockState
    else Export::Tabular::CensusFlock
    end
  end
end
