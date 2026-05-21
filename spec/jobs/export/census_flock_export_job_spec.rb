#  Copyright (c) 2017-2022, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

require "spec_helper"

describe Export::CensusFlockExportJob do
  subject { Export::CensusFlockExportJob.new(format, user.id, 2012, type: "", filename: "flock_export") }

  let(:file) { subject.user_job_result }

  let(:user) { people(:top_leader) }

  context "creates a CSV-Export" do
    let(:format) { :csv }

    it "and saves it" do
      subject.enqueue!
      subject.perform

      lines = file.read.lines
      expect(lines.size).to eq(6)
    end
  end
end
