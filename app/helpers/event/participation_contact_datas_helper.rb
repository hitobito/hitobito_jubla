#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Event::ParticipationContactDatasHelper
  LOCKED_CONTACT_ATTRS = [:first_name, :last_name].freeze

  def locked_contact_attr_options(attr, entry)
    return {} unless LOCKED_CONTACT_ATTRS.include?(attr)
    return {} unless entry.respond_to?(:person)
    return {} unless entry.person.send(attr).present?

    { readonly: true, help_inline: t('event.participation_contact_datas.fields.readonly_hint') }
  end
end
