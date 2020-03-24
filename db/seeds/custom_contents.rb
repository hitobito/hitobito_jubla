# encoding: utf-8

#  Copyright (c) 2012-2017, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.


CustomContent.seed_once(:key,
  {
    key: CensusMailer::CONTENT_INVITATION,
    placeholders_optional: 'due-date'
  },

  {
    key: CensusMailer::CONTENT_REMINDER,
    placeholders_optional: 'recipient-names, due-date, contact-address, census-url'
  },

  { 
    key: AlumniMailer::NEW_MEMBER,
    placeholders_required: 'recipient-name, recipient-profile-url'
  },

  { 
    key: AlumniMailer::NEW_MEMBER_FLOCK,
    placeholders_required: 'recipient-name, recipient-profile-url'
  },
)

CustomContent::Translation.seed_once(:custom_content_id, :locale,
  {
    custom_content_id: CustomContent.where(key: CensusMailer::CONTENT_INVITATION).first.id,
    locale: 'de',
    label: 'Bestandesmeldung: E-Mail Aufruf',
    subject: 'Bestandesmeldung ausfüllen',
    body: "Hallo!<br/><br/>Auch dieses Jahr erheben wir die aktuellen Mitgliederzahlen. Wir bitten dich, den Bestand deiner Gruppe zu aktualisieren und die Bestandesmeldung bis am {due-date} zu bestätigen.<br/><br/>Vielen Dank für deine Mithilfe.<br/><br/>Deine Jubla"
  },

  {
    custom_content_id: CustomContent.where(key: CensusMailer::CONTENT_REMINDER).first.id,
    locale: 'de',
    label: 'Bestandesmeldung: E-Mail Erinnerung',
    subject: 'Bestandesmeldung ausfüllen!',
    body: "Hallo {recipient-names}<br/><br/>Wir bitten dich, den Bestand deiner Gruppe zu aktualisieren und die Bestandesmeldung bis am {due-date} zu bestätigen:<br/><br/>{census-url}<br/><br/>Vielen Dank für deine Mithilfe. Bei Fragen kannst du dich an die folgende Adresse wenden:<br/><br/>{contact-address}<br/><br/>Deine Jubla"
  },

  { 
    custom_content_id: CustomContent.where(key: AlumniMailer::NEW_MEMBER).first.id,
    locale: 'de',
    label: 'Ehemalige: Benachrichtigung',
    subject: 'Danke für deinen Einsatz bei der Jubla!',
    body: "Liebe/Lieber {recipient-name}<br/><br/>Herzlichen Dank für dein wichtiges Engagement für Jungwacht Blauring. Bestimmt hast du viele tolle Erlebnisse gehabt und gute Freundschaften aufgebaut – eben Lebensfreu(n)de.<br/><br/> \"Freude und Freunde – und das fürs Leben\" soll auch heissen, dass deine Jubla-Zeit jetzt nicht vorbei sein muss. Als frischgebackene Ehemalige / frischgebackener Ehemaliger bist du nämlich ein wichtiger Teil für Jungwacht Blauring. Vielleicht braucht deine ehemalige Schar jedes Jahr tatkräftige Unterstützung beim Sommerlager-Aufbau? Oder der entsprechende Kantonalverband ist auf der Suche nach Leuten, die beim kantonalen Geländespiel die Verpflegung organisieren? Es wäre doch toll, wenn du auf diese oder andere Arten noch mit Jungwacht Blauring in Verbindung bleiben könntest. Darum kannst du in deinem Profil auf der <a href=\"{recipient-profile-url}\">jubla.db</a> bestimmen, welche Ebene dich in Zukunft kontaktieren und dir Informationen senden darf. Vielen Dank nochmals für dein Engagement – auch über deine aktive Zeit hinaus.<br/><br/>Liebe Grüsse<br/>Jungwacht Blauring Schweiz"
  },

  { 
    custom_content_id: CustomContent.where(key: AlumniMailer::NEW_MEMBER_FLOCK).first.id,
    locale: 'de',
    label: 'Ehemalige: Benachrichtigung Schar',
    subject: 'Danke für deinen Einsatz bei der Schar!',
    body: "Liebe/Lieber {recipient-name}<br/><br/>Herzlichen Dank für dein wichtiges Engagement für Jungwacht Blauring. Bestimmt hast du viele tolle Erlebnisse gehabt und gute Freundschaften aufgebaut – eben Lebensfreu(n)de.<br/><br/> \"Freude und Freunde – und das fürs Leben\" soll auch heissen, dass deine Jubla-Zeit jetzt nicht vorbei sein muss. Als frischgebackene Ehemalige / frischgebackener Ehemaliger bist du nämlich ein wichtiger Teil für Jungwacht Blauring. Vielleicht braucht deine ehemalige Schar jedes Jahr tatkräftige Unterstützung beim Sommerlager-Aufbau? Oder der entsprechende Kantonalverband ist auf der Suche nach Leuten, die beim kantonalen Geländespiel die Verpflegung organisieren? Es wäre doch toll, wenn du auf diese oder andere Arten noch mit Jungwacht Blauring in Verbindung bleiben könntest. Darum kannst du in deinem Profil auf der <a href=\"{recipient-profile-url}\">jubla.db</a> bestimmen, welche Ebene dich in Zukunft kontaktieren und dir Informationen senden darf. Vielen Dank nochmals für dein Engagement – auch über deine aktive Zeit hinaus.<br/><br/>Liebe Grüsse<br/>Jungwacht Blauring Schweiz"
  },
)
