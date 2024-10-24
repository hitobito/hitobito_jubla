#  Copyright (c) 2023, Cevi Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

class Export::CensusFlockExportJob < Export::ExportBaseJob
  self.parameters = PARAMETERS + [:year]

  def initialize(format, user_id, year, options)
    super(format, user_id, options)
    @year = year
  end

  private

  def data
    exporter.export(@format, @year)
  end

  def exporter
    return Export::Tabular::CensusFlockFederation if @options[:type] == "federation"
    return Export::Tabular::CensusFlockState if @options[:type] == "state"

    Export::Tabular::CensusFlock
  end
end
