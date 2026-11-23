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

  [NejbRole::External, NejbRole::DispatchAddress, NejbRole::Joiner].each do |base_class|
    context base_class.to_s do
      it "is a NejbRole and not one of the Jubla::Role classes" do
        expect(base_class.superclass).to eq NejbRole
      end
    end
  end

  {
    NejbRole::External => %w[
      Group::NetzwerkEhemaligeJungwachtBlauring::External
      Group::KantonEhemaligenverein::External
      Group::RegionEhemaligenverein::External
      Group::NejbSchar::External
      Group::NejbSimpleGroup::External
    ],
    NejbRole::DispatchAddress => %w[
      Group::Nejb::DispatchAddress
      Group::NetzwerkEhemaligeJungwachtBlauring::DispatchAddress
      Group::KantonEhemaligenverein::DispatchAddress
      Group::RegionEhemaligenverein::DispatchAddress
      Group::NejbSchar::DispatchAddress
      Group::NejbSimpleGroup::DispatchAddress
    ],
    NejbRole::Joiner => %w[
      Group::NetzwerkEhemaligeJungwachtBlauring::NejbJoiner
      Group::KantonEhemaligenverein::NejbJoiner
      Group::RegionEhemaligenverein::NejbJoiner
      Group::NejbSchar::NejbJoiner
      Group::NejbSimpleGroup::NewJoiner
    ]
  }.each do |base_class, roles|
    roles.each do |role|
      context role do
        it "is a #{base_class}" do
          expect(role.constantize).to be < base_class
        end

        it "uses the NullAlumnusManager" do
          expect(role.constantize.new.alumnus_manager).to be_a Jubla::Role::NullAlumnusManager
        end
      end
    end
  end
end
