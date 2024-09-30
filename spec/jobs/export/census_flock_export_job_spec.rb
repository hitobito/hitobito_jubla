#  Copyright (c) 2017-2022, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

require "spec_helper"

describe Export::CensusFlockExportJob do
  subject { Export::CensusFlockExportJob.new(format, user.id, 2012, type: '', filename: filename) }

  let(:filename) { AsyncDownloadFile.create_name("flock_export", user.id) }
  let(:file) { AsyncDownloadFile.from_filename(filename, format) }

  let(:user) { people(:top_leader) }

  context "creates a CSV-Export" do
    let(:format) { :csv }

    it "and saves it" do
      subject.perform

      lines = file.read.lines
      expect(lines.size).to eq(6)
    end
  end
end
