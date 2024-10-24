# Hitobito Jubla

This hitobito wagon defines the organization hierarchy with groups and roles of Jungwacht Blauring Schweiz.

Additional features include member census, camps and course conditions.


# Jubla Organization Hierarchy

<!-- roles:start -->
    * Organisation
      * Organisation
        * Administrator: 2FA [:layer_and_below_full, :admin]
    * Bund
      * Bund
        * Adressverwaltung: [:group_full]
        * Ehemalig: [:group_read]
        * Extern: []
        * Versandadresse: []
        * IT Support: [:impersonation]
      * Bundesleitung
        * Mitglied: [:admin, :layer_and_below_full, :contact_data]
        * Präses: [:admin, :layer_and_below_full, :contact_data]
        * Adressverwaltung: [:group_full]
        * Ehemalig: [:group_read]
        * Extern: []
        * Versandadresse: []
      * Verbandsleitung
        * Leitung: [:group_full, :contact_data]
        * Kassier/in: [:contact_data, :group_read, :finance]
        * Mitglied: [:contact_data, :group_read]
        * Adressverwaltung: [:group_full]
        * Ehemalig: [:group_read]
        * Extern: []
        * Versandadresse: []
      * Fachgruppe
        * Leitung: [:group_full, :contact_data]
        * Mitglied: [:group_read, :contact_data]
        * Adressverwaltung: [:group_full]
        * Ehemalig: [:group_read]
        * Extern: []
        * Versandadresse: []
      * Arbeitsgruppe
        * Leitung: [:group_full, :contact_data]
        * Mitglied: [:group_read]
        * Adressverwaltung: [:group_full]
        * Ehemalig: [:group_read]
        * Extern: []
        * Versandadresse: []
      * Ehemalige
        * Leitung: [:group_and_below_full, :contact_data, :alumnus_below_full]
        * Adressverwaltung: [:group_and_below_full]
        * Kassier/in: [:group_and_below_read]
        * Mitglied: [:group_read]
        * Extern: []
        * Versandadresse: []
    * Kanton
      * Kanton
        * Coach: [:contact_data, :group_read]
        * Adressverwaltung: [:group_full]
        * Ehemalig: [:group_read]
        * Extern: []
        * Versandadresse: []
      * Arbeitsstelle
        * Leitung: [:layer_and_below_full, :contact_data]
        * Adressverwaltung: [:group_full]
        * Ehemalig: [:group_read]
        * Extern: []
        * Versandadresse: []
      * Kantonsleitung
        * Leitung: [:group_full, :layer_and_below_read, :contact_data]
        * Mitglied: [:group_read, :contact_data]
        * Stellenbegleitung: [:layer_and_below_read]
        * Präses: [:group_read, :contact_data]
        * Adressverwaltung: [:group_full]
        * Ehemalig: [:group_read]
        * Extern: []
        * Versandadresse: []
      * Fachgruppe
        * Leitung: [:group_full, :contact_data]
        * Mitglied: [:group_read]
        * Adressverwaltung: [:group_full]
        * Ehemalig: [:group_read]
        * Extern: []
        * Versandadresse: []
      * Arbeitsgruppe
        * Leitung: [:group_full, :contact_data]
        * Mitglied: [:group_read]
        * Adressverwaltung: [:group_full]
        * Ehemalig: [:group_read]
        * Extern: []
        * Versandadresse: []
      * Ehemalige
        * Leitung: [:group_and_below_full, :contact_data, :alumnus_below_full]
        * Adressverwaltung: [:group_and_below_full]
        * Kassier/in: [:group_and_below_read]
        * Mitglied: [:group_read]
        * Extern: []
        * Versandadresse: []
    * Region
      * Region
        * Coach: [:contact_data, :group_read]
        * Adressverwaltung: [:group_full]
        * Ehemalig: [:group_read]
        * Extern: []
        * Versandadresse: []
      * Regionalleitung
        * Leitung: [:layer_and_below_full, :contact_data]
        * Mitglied: [:layer_and_below_read, :contact_data]
        * Präses: [:layer_and_below_read, :contact_data]
        * Adressverwaltung: [:group_full]
        * Ehemalig: [:group_read]
        * Extern: []
        * Versandadresse: []
      * Fachgruppe
        * Leitung: [:group_full, :contact_data]
        * Mitglied: [:group_read]
        * Adressverwaltung: [:group_full]
        * Ehemalig: [:group_read]
        * Extern: []
        * Versandadresse: []
      * Arbeitsgruppe
        * Leitung: [:group_full, :contact_data]
        * Mitglied: [:group_read]
        * Adressverwaltung: [:group_full]
        * Ehemalig: [:group_read]
        * Extern: []
        * Versandadresse: []
      * Ehemalige
        * Leitung: [:group_and_below_full, :contact_data, :alumnus_below_full]
        * Adressverwaltung: [:group_and_below_full]
        * Kassier/in: [:group_and_below_read]
        * Mitglied: [:group_read]
        * Extern: []
        * Versandadresse: []
    * Schar
      * Schar
        * Scharleitung: [:layer_and_below_full, :contact_data, :approve_applications]
        * Lagerleitung: [:layer_and_below_full, :contact_data]
        * Präses: [:layer_and_below_read, :contact_data]
        * Kassier/in: [:layer_and_below_read, :contact_data]
        * Leiter/in: [:layer_and_below_read]
        * Adressverwaltung: [:layer_and_below_full]
        * Ehemalig: [:group_read]
        * Extern: []
        * Versandadresse: []
      * Kindergruppe
        * Leitung: [:group_full]
        * Kind: [:group_read]
        * Adressverwaltung: [:group_full]
        * Ehemalig: [:group_read]
        * Extern: []
        * Versandadresse: []
      * Ehemalige
        * Leitung: [:group_and_below_full, :contact_data, :alumnus_below_full]
        * Adressverwaltung: [:group_and_below_full]
        * Kassier/in: [:group_and_below_read]
        * Mitglied: [:group_read]
        * Extern: []
        * Versandadresse: []
    * NEJB
      * NEJB
        * Adressverwaltung: [:group_full]
        * Versandadresse: []
        * IT Support: [:admin, :impersonation]
      * NEJB Bundesleitung
        * Adressverwaltung: [:admin, :layer_and_below_full, :contact_data]
      * Netzwerk Ehemalige Jungwacht Blauring
        * Leitung: [:group_and_below_full, :contact_data]
        * Adressverwaltung: [:group_and_below_full]
        * Kassier*in: [:group_and_below_read]
        * Aktivmitglied: [:group_read]
        * Passivmitglied: [:group_read]
        * Kollektivmitglied: [:group_read]
        * Neumitglied: []
        * Extern: []
        * Versandadresse: []
    * Kanton (Ehemalige)
      * Kanton (Ehemalige)
        * Adressverwaltung: [:admin, :layer_and_below_full, :contact_data]
      * Kantonaler Ehemaligenverein
        * Leitung: [:group_and_below_full, :contact_data]
        * Adressverwaltung: [:group_and_below_full]
        * Kassier*in: [:group_and_below_read]
        * Mitglied Ehemalige: [:group_read]
        * Neumitglied: []
        * Extern: []
        * Versandadresse: []
    * Region (Ehemalige)
      * Region (Ehemalige)
        * Adressverwaltung: [:admin, :layer_and_below_full, :contact_data]
      * Regionaler Ehemaligenverein
        * Leitung: [:group_and_below_full, :contact_data]
        * Adressverwaltung: [:group_and_below_full]
        * Kassier*in: [:group_and_below_read]
        * Mitglied Ehemalige: [:group_read]
        * Neumitglied: []
        * Extern: []
        * Versandadresse: []
    * Ehemaligenschar
      * Ehemaligenschar
        * Leitung: [:group_and_below_full, :contact_data]
        * Adressverwaltung: [:group_and_below_full]
        * Kassier*in: [:group_and_below_read]
        * Mitglied Ehemalige: [:group_read]
        * Neumitglied: []
        * Extern: []
        * Versandadresse: []
    * Global
      * Einfache Gruppe
        * Leitung: [:group_full]
        * Mitglied: [:group_read]
        * Adressverwaltung: [:group_full]
        * Ehemalig: [:group_read]
        * Extern: []
        * Versandadresse: []

(Output of rake app:hitobito:roles)
<!-- roles:end -->