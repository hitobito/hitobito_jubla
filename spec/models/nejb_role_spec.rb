#  Copyright (c) 2012-2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require "spec_helper"

describe NejbRole do
  it "is a Role" do
    expect(subject).to be_a Role
  end

  it "is a Jubla::Role" do
    expect(subject).to be_a Jubla::Role
  end

  it "uses the NullAlumnusManager" do
    expect(subject.alumnus_manager).to be_a Jubla::Role::NullAlumnusManager
  end

  %w[
    Group::NejbSchar::GroupAdmin
  ].each do |role|
    context role do
      it "is a NeJbRole" do
        expect(role.safe_constantize.new).to be_a NejbRole
      end
    end
  end
end
