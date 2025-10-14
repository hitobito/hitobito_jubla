#  Copyright (c) 2025, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::Wizards::Steps::NewUserForm
  extend ActiveSupport::Concern
  PHONE_NUMBER_LABEL = "Privat"

  prepended do
    attribute :address_care_of, :string
    attribute :street, :string
    attribute :housenumber, :string

    attribute :postbox, :string
    attribute :zip_code, :string
    attribute :town, :string
    attribute :country, :string

    attribute :phone_number, :string
    attribute :email, :string

    validates :email, presence: true

    validate :assert_valid_phone_number
  end

  # rubocop:todo Metrics/MethodLength
  # rubocop:todo Metrics/AbcSize
  def initialize(...) # rubocop:todo Metrics/CyclomaticComplexity # rubocop:todo Metrics/AbcSize # rubocop:todo Metrics/MethodLength
    super

    if current_user
      self.id = current_user.id
      self.gender ||= current_user.gender
      self.first_name ||= current_user.first_name
      self.last_name ||= current_user.last_name
      self.birthday ||= current_user.birthday
      self.email ||= current_user.email
      self.address_care_of ||= current_user.address_care_of
      self.street ||= current_user.street
      self.housenumber ||= current_user.housenumber
      self.postbox ||= current_user.postbox
      self.zip_code ||= current_user.zip_code
      self.town ||= current_user.town
      self.country ||= current_user.country
      self.phone_number ||= current_user.phone_numbers.find_by(label: PHONE_NUMBER_LABEL)&.number
    else
      self.country ||= Settings.addresses.imported_countries.to_a.first
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def person_attributes
    attributes.compact.symbolize_keys.except(:phone_number).then do |attrs|
      next attrs if phone_number.blank?

      attrs.merge(phone_numbers_attributes: [{label: PHONE_NUMBER_LABEL, number: phone_number,
                                              public: false}.compact])
    end
  end

  private

  def assert_valid_phone_number
    # rubocop:todo Layout/LineLength
    if phone_number.present? && PhoneNumber.new(number: phone_number).tap(&:valid?).errors.key?(:number)
      # rubocop:enable Layout/LineLength
      errors.add(:phone_number, :invalid)
    end
  end
end
