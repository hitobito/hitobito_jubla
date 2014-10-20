# encoding: utf-8

#  Copyright (c) 2012-2014, insieme Schweiz. This file is part of
#  hitobito_insieme and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_insieme.

class ModulusValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return true if value.blank? || options.nil? || !options.include?(:multiple)
    if value % options[:multiple] != 0
      record.errors[attribute] << (options[:message] ||
        I18n.t('activerecord.errors.messages.must_be_multiple_of', multiple: options[:multiple]))
    end
  end
end
