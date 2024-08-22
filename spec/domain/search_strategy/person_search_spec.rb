#  Copyright (c) 2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require "spec_helper"

describe SearchStrategies::PersonSearch do
  before do
    people(:flock_leader).update!(name_mother: "Helen", name_father: "Jack", nationality: "Kumbaja",
                            profession: "Bänker", bank_account: "Account", ahv_number_old: 7569217076985,
                            insurance_company: "Axa", insurance_number: 6566)
  end

  describe "#search_fulltext" do
    let(:user) { people(:top_leader) }

    it "finds accessible person by mother name" do
      result = search_class(people(:flock_leader).name_mother).search_fulltext
      expect(result).to include(people(:flock_leader))
    end

    it "finds accessible person by father name" do
      result = search_class(people(:flock_leader).name_father).search_fulltext
      expect(result).to include(people(:flock_leader))
    end

    it "finds accessible person by nationality" do
      result = search_class(people(:flock_leader).nationality).search_fulltext
      expect(result).to include(people(:flock_leader))
    end

    it "finds accessible person by profession" do
      result = search_class(people(:flock_leader).profession).search_fulltext
      expect(result).to include(people(:flock_leader))
    end

    it "finds accessible person by bank account" do
      result = search_class(people(:flock_leader).bank_account).search_fulltext
      expect(result).to include(people(:flock_leader))
    end

    it "finds accessible person by ahv number old" do
      result = search_class(people(:flock_leader).ahv_number_old).search_fulltext
      expect(result).to include(people(:flock_leader))
    end

    it "finds accessible person by insurance company" do
      result = search_class(people(:flock_leader).insurance_company).search_fulltext
      expect(result).to include(people(:flock_leader))
    end

    it "finds accessible person by insurance number" do
      result = search_class(people(:flock_leader).insurance_number.to_s).search_fulltext
      expect(result).to include(people(:flock_leader))
    end
  end

  def search_class(term = nil, page = nil)
    described_class.new(user, term, page)
  end
end
