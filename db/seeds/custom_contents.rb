# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.


CustomContent.seed_once(:key,
  {key: CensusMailer::CONTENT_INVITATION,
   placeholders_optional: 'due-date'},

  {key: CensusMailer::CONTENT_REMINDER,
   placeholders_optional: 'recipient-names, due-date, contact-address, census-url'},

)

CustomContent::Translation.seed_once(:custom_content_id, :locale,
  {custom_content_id: CustomContent.where(key: CensusMailer::CONTENT_INVITATION).first.id,
   locale: 'de',
   label: 'Bestandesmeldung: E-Mail Aufruf',
   subject: 'Bestandesmeldung ausfüllen',
   body: "Hallo!<br/><br/>Auch dieses Jahr erheben wir die aktuellen Mitgliederzahlen. Wir bitten dich, den Bestand deiner Gruppe zu aktualisieren und die Bestandesmeldung bis am {due-date} zu bestätigen.<br/><br/>Vielen Dank für deine Mithilfe.<br/><br/>Deine Jubla"},

  {custom_content_id: CustomContent.where(key: CensusMailer::CONTENT_REMINDER).first.id,
   locale: 'de',
   label: 'Bestandesmeldung: E-Mail Erinnerung',
   subject: 'Bestandesmeldung ausfüllen!',
   body: "Hallo {recipient-names}<br/><br/>Wir bitten dich, den Bestand deiner Gruppe zu aktualisieren und die Bestandesmeldung bis am {due-date} zu bestätigen:<br/><br/>{census-url}<br/><br/>Vielen Dank für deine Mithilfe. Bei Fragen kannst du dich an die folgende Adresse wenden:<br/><br/>{contact-address}<br/><br/>Deine Jubla"},
  
)
