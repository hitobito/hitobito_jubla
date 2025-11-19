# Hitobito Jubla

This hitobito wagon defines the organization hierarchy with groups and roles of Jungwacht Blauring Schweiz.

Additional features include member census, camps and course conditions.


# Jubla Organization Hierarchy

<!-- roles:start -->
    * Organisation
      * Organisation
        * Administrator: 2FA [:layer_and_below_full, :admin]  --  (Group::Root::Admin)
    * Bund
      * Bund
        * Adressverwaltung: [:group_full]  --  (Group::Federation::GroupAdmin)
        * Austritt: [:group_read]  --  (Group::Federation::Alumnus)
        * Extern: []  --  (Group::Federation::External)
        * Versandadresse: []  --  (Group::Federation::DispatchAddress)
        * IT Support: [:impersonation]  --  (Group::Federation::ItSupport)
      * Bundesleitung
        * Mitglied: 2FA [:admin, :layer_and_below_full, :contact_data]  --  (Group::FederalBoard::Member)
        * Präses: 2FA [:admin, :layer_and_below_full, :contact_data]  --  (Group::FederalBoard::President)
        * Adressverwaltung: [:group_full]  --  (Group::FederalBoard::GroupAdmin)
        * Austritt: [:group_read]  --  (Group::FederalBoard::Alumnus)
        * Extern: []  --  (Group::FederalBoard::External)
        * Versandadresse: []  --  (Group::FederalBoard::DispatchAddress)
        * Kassier*in: 2FA [:layer_and_below_read, :finance, :contact_data]  --  (Group::FederalBoard::Treasurer)
      * Verbandsleitung
        * Leitung: [:group_full, :contact_data]  --  (Group::OrganizationBoard::Leader)
        * Kassier*in: 2FA [:contact_data, :group_read, :finance]  --  (Group::OrganizationBoard::Treasurer)
        * Mitglied: [:contact_data, :group_read]  --  (Group::OrganizationBoard::Member)
        * Adressverwaltung: [:group_full]  --  (Group::OrganizationBoard::GroupAdmin)
        * Austritt: [:group_read]  --  (Group::OrganizationBoard::Alumnus)
        * Extern: []  --  (Group::OrganizationBoard::External)
        * Versandadresse: []  --  (Group::OrganizationBoard::DispatchAddress)
      * Fachgruppe
        * Leitung: [:group_full, :contact_data]  --  (Group::FederalProfessionalGroup::Leader)
        * Mitglied: [:group_read, :contact_data]  --  (Group::FederalProfessionalGroup::Member)
        * Adressverwaltung: [:group_full]  --  (Group::FederalProfessionalGroup::GroupAdmin)
        * Austritt: [:group_read]  --  (Group::FederalProfessionalGroup::Alumnus)
        * Extern: []  --  (Group::FederalProfessionalGroup::External)
        * Versandadresse: []  --  (Group::FederalProfessionalGroup::DispatchAddress)
        * Kassier*in: 2FA [:layer_and_below_read, :finance, :contact_data]  --  (Group::FederalProfessionalGroup::Treasurer)
      * Arbeitsgruppe
        * Leitung: [:group_full, :contact_data]  --  (Group::FederalWorkGroup::Leader)
        * Mitglied: [:group_read]  --  (Group::FederalWorkGroup::Member)
        * Adressverwaltung: [:group_full]  --  (Group::FederalWorkGroup::GroupAdmin)
        * Austritt: [:group_read]  --  (Group::FederalWorkGroup::Alumnus)
        * Extern: []  --  (Group::FederalWorkGroup::External)
        * Versandadresse: []  --  (Group::FederalWorkGroup::DispatchAddress)
        * Kassier*in: 2FA [:layer_and_below_read, :finance, :contact_data]  --  (Group::FederalWorkGroup::Treasurer)
      * Ehemalige
        * Leitung: [:group_and_below_full, :contact_data, :alumnus_below_full]  --  (Group::FederalAlumnusGroup::Leader)
        * Adressverwaltung: [:group_and_below_full]  --  (Group::FederalAlumnusGroup::GroupAdmin)
        * Kassier*in: [:group_and_below_read]  --  (Group::FederalAlumnusGroup::Treasurer)
        * Mitglied: [:group_read]  --  (Group::FederalAlumnusGroup::Member)
        * Extern: []  --  (Group::FederalAlumnusGroup::External)
        * Versandadresse: []  --  (Group::FederalAlumnusGroup::DispatchAddress)
    * Kanton
      * Kanton
        * Coach: [:contact_data, :group_read]  --  (Group::State::Coach)
        * Adressverwaltung: [:group_full]  --  (Group::State::GroupAdmin)
        * Austritt: [:group_read]  --  (Group::State::Alumnus)
        * Extern: []  --  (Group::State::External)
        * Versandadresse: []  --  (Group::State::DispatchAddress)
      * Arbeitsstelle
        * Leitung: [:layer_and_below_full, :contact_data]  --  (Group::StateAgency::Leader)
        * Adressverwaltung: [:group_full]  --  (Group::StateAgency::GroupAdmin)
        * Austritt: [:group_read]  --  (Group::StateAgency::Alumnus)
        * Extern: []  --  (Group::StateAgency::External)
        * Versandadresse: []  --  (Group::StateAgency::DispatchAddress)
      * Kantonsleitung
        * Leitung: [:group_full, :layer_and_below_read, :contact_data]  --  (Group::StateBoard::Leader)
        * Mitglied: [:group_read, :contact_data]  --  (Group::StateBoard::Member)
        * Stellenbegleitung: [:layer_and_below_read]  --  (Group::StateBoard::Supervisor)
        * Präses: [:group_read, :contact_data]  --  (Group::StateBoard::President)
        * Adressverwaltung: [:group_full]  --  (Group::StateBoard::GroupAdmin)
        * Austritt: [:group_read]  --  (Group::StateBoard::Alumnus)
        * Extern: []  --  (Group::StateBoard::External)
        * Versandadresse: []  --  (Group::StateBoard::DispatchAddress)
      * Fachgruppe
        * Leitung: [:group_full, :contact_data]  --  (Group::StateProfessionalGroup::Leader)
        * Mitglied: [:group_read]  --  (Group::StateProfessionalGroup::Member)
        * Adressverwaltung: [:group_full]  --  (Group::StateProfessionalGroup::GroupAdmin)
        * Austritt: [:group_read]  --  (Group::StateProfessionalGroup::Alumnus)
        * Extern: []  --  (Group::StateProfessionalGroup::External)
        * Versandadresse: []  --  (Group::StateProfessionalGroup::DispatchAddress)
      * Arbeitsgruppe
        * Leitung: [:group_full, :contact_data]  --  (Group::StateWorkGroup::Leader)
        * Mitglied: [:group_read]  --  (Group::StateWorkGroup::Member)
        * Adressverwaltung: [:group_full]  --  (Group::StateWorkGroup::GroupAdmin)
        * Austritt: [:group_read]  --  (Group::StateWorkGroup::Alumnus)
        * Extern: []  --  (Group::StateWorkGroup::External)
        * Versandadresse: []  --  (Group::StateWorkGroup::DispatchAddress)
      * Ehemalige
        * Leitung: [:group_and_below_full, :contact_data, :alumnus_below_full]  --  (Group::StateAlumnusGroup::Leader)
        * Adressverwaltung: [:group_and_below_full]  --  (Group::StateAlumnusGroup::GroupAdmin)
        * Kassier*in: [:group_and_below_read]  --  (Group::StateAlumnusGroup::Treasurer)
        * Mitglied: [:group_read]  --  (Group::StateAlumnusGroup::Member)
        * Extern: []  --  (Group::StateAlumnusGroup::External)
        * Versandadresse: []  --  (Group::StateAlumnusGroup::DispatchAddress)
    * Region
      * Region
        * Coach: [:contact_data, :group_read]  --  (Group::Region::Coach)
        * Adressverwaltung: [:group_full]  --  (Group::Region::GroupAdmin)
        * Austritt: [:group_read]  --  (Group::Region::Alumnus)
        * Extern: []  --  (Group::Region::External)
        * Versandadresse: []  --  (Group::Region::DispatchAddress)
      * Regionalleitung
        * Leitung: [:layer_and_below_full, :contact_data]  --  (Group::RegionalBoard::Leader)
        * Mitglied: [:layer_and_below_read, :contact_data]  --  (Group::RegionalBoard::Member)
        * Präses: [:layer_and_below_read, :contact_data]  --  (Group::RegionalBoard::President)
        * Adressverwaltung: [:group_full]  --  (Group::RegionalBoard::GroupAdmin)
        * Austritt: [:group_read]  --  (Group::RegionalBoard::Alumnus)
        * Extern: []  --  (Group::RegionalBoard::External)
        * Versandadresse: []  --  (Group::RegionalBoard::DispatchAddress)
      * Fachgruppe
        * Leitung: [:group_full, :contact_data]  --  (Group::RegionalProfessionalGroup::Leader)
        * Mitglied: [:group_read]  --  (Group::RegionalProfessionalGroup::Member)
        * Adressverwaltung: [:group_full]  --  (Group::RegionalProfessionalGroup::GroupAdmin)
        * Austritt: [:group_read]  --  (Group::RegionalProfessionalGroup::Alumnus)
        * Extern: []  --  (Group::RegionalProfessionalGroup::External)
        * Versandadresse: []  --  (Group::RegionalProfessionalGroup::DispatchAddress)
      * Arbeitsgruppe
        * Leitung: [:group_full, :contact_data]  --  (Group::RegionalWorkGroup::Leader)
        * Mitglied: [:group_read]  --  (Group::RegionalWorkGroup::Member)
        * Adressverwaltung: [:group_full]  --  (Group::RegionalWorkGroup::GroupAdmin)
        * Austritt: [:group_read]  --  (Group::RegionalWorkGroup::Alumnus)
        * Extern: []  --  (Group::RegionalWorkGroup::External)
        * Versandadresse: []  --  (Group::RegionalWorkGroup::DispatchAddress)
      * Ehemalige
        * Leitung: [:group_and_below_full, :contact_data, :alumnus_below_full]  --  (Group::RegionalAlumnusGroup::Leader)
        * Adressverwaltung: [:group_and_below_full]  --  (Group::RegionalAlumnusGroup::GroupAdmin)
        * Kassier*in: [:group_and_below_read]  --  (Group::RegionalAlumnusGroup::Treasurer)
        * Mitglied: [:group_read]  --  (Group::RegionalAlumnusGroup::Member)
        * Extern: []  --  (Group::RegionalAlumnusGroup::External)
        * Versandadresse: []  --  (Group::RegionalAlumnusGroup::DispatchAddress)
    * Schar
      * Schar
        * Scharleitung: [:layer_and_below_full, :contact_data, :approve_applications, :manual_deletion]  --  (Group::Flock::Leader)
        * Lagerleitung: [:layer_and_below_full, :contact_data]  --  (Group::Flock::CampLeader)
        * Präses: [:layer_and_below_read, :contact_data]  --  (Group::Flock::President)
        * Kassier*in: 2FA [:layer_and_below_read, :contact_data, :finance]  --  (Group::Flock::Treasurer)
        * Leiter/in: [:layer_and_below_read]  --  (Group::Flock::Guide)
        * Adressverwaltung: [:layer_and_below_full]  --  (Group::Flock::GroupAdmin)
        * Austritt: [:group_read]  --  (Group::Flock::Alumnus)
        * Extern: []  --  (Group::Flock::External)
        * Versandadresse: []  --  (Group::Flock::DispatchAddress)
      * Kindergruppe
        * Leitung: [:group_full]  --  (Group::ChildGroup::Leader)
        * Kind: []  --  (Group::ChildGroup::Child)
        * Adressverwaltung: [:group_full]  --  (Group::ChildGroup::GroupAdmin)
        * Austritt: [:group_read]  --  (Group::ChildGroup::Alumnus)
        * Extern: []  --  (Group::ChildGroup::External)
        * Versandadresse: []  --  (Group::ChildGroup::DispatchAddress)
      * Ehemalige
        * Leitung: [:group_and_below_full, :contact_data, :alumnus_below_full]  --  (Group::FlockAlumnusGroup::Leader)
        * Adressverwaltung: [:group_and_below_full]  --  (Group::FlockAlumnusGroup::GroupAdmin)
        * Kassier*in: [:group_and_below_read]  --  (Group::FlockAlumnusGroup::Treasurer)
        * Mitglied: [:group_read]  --  (Group::FlockAlumnusGroup::Member)
        * Extern: []  --  (Group::FlockAlumnusGroup::External)
        * Versandadresse: []  --  (Group::FlockAlumnusGroup::DispatchAddress)
    * NEJB
      * NEJB
        * Adressverwaltung: [:group_full]  --  (Group::Nejb::GroupAdmin)
        * Versandadresse: []  --  (Group::Nejb::DispatchAddress)
        * IT Support: 2FA [:admin, :impersonation]  --  (Group::Nejb::ITSupport)
      * NEJB Bundesleitung
        * Adressverwaltung: 2FA [:admin, :layer_and_below_full, :contact_data]  --  (Group::NejbBundesleitung::GroupAdmin)
      * Netzwerk Ehemalige Jungwacht Blauring
        * Leitung: [:group_and_below_full, :contact_data]  --  (Group::NetzwerkEhemaligeJungwachtBlauring::Leader)
        * Adressverwaltung: [:group_and_below_full]  --  (Group::NetzwerkEhemaligeJungwachtBlauring::GroupAdmin)
        * Kassier*in: [:group_and_below_read]  --  (Group::NetzwerkEhemaligeJungwachtBlauring::Treasurer)
        * Aktivmitglied: [:group_read]  --  (Group::NetzwerkEhemaligeJungwachtBlauring::ActiveMember)
        * Passivmitglied: [:group_read]  --  (Group::NetzwerkEhemaligeJungwachtBlauring::PassiveMember)
        * Kollektivmitglied: [:group_read]  --  (Group::NetzwerkEhemaligeJungwachtBlauring::CollectiveMember)
        * Neumitglied: []  --  (Group::NetzwerkEhemaligeJungwachtBlauring::NejbJoiner)
        * Extern: []  --  (Group::NetzwerkEhemaligeJungwachtBlauring::External)
        * Versandadresse: []  --  (Group::NetzwerkEhemaligeJungwachtBlauring::DispatchAddress)
    * Kanton (Ehemalige)
      * Kanton (Ehemalige)
        * Adressverwaltung: [:admin, :layer_and_below_full, :contact_data]  --  (Group::NejbKanton::GroupAdmin)
      * Kantonaler Ehemaligenverein
        * Leitung: [:group_and_below_full, :contact_data]  --  (Group::KantonEhemaligenverein::Leader)
        * Adressverwaltung: [:group_and_below_full]  --  (Group::KantonEhemaligenverein::GroupAdmin)
        * Kassier*in: [:group_and_below_read]  --  (Group::KantonEhemaligenverein::Treasurer)
        * Mitglied Ehemalige: [:group_read]  --  (Group::KantonEhemaligenverein::NejbMember)
        * Neumitglied: []  --  (Group::KantonEhemaligenverein::NejbJoiner)
        * Extern: []  --  (Group::KantonEhemaligenverein::External)
        * Versandadresse: []  --  (Group::KantonEhemaligenverein::DispatchAddress)
    * Region (Ehemalige)
      * Region (Ehemalige)
        * Adressverwaltung: [:admin, :layer_and_below_full, :contact_data]  --  (Group::NejbRegion::GroupAdmin)
      * Regionaler Ehemaligenverein
        * Leitung: [:group_and_below_full, :contact_data]  --  (Group::RegionEhemaligenverein::Leader)
        * Adressverwaltung: [:group_and_below_full]  --  (Group::RegionEhemaligenverein::GroupAdmin)
        * Kassier*in: [:group_and_below_read]  --  (Group::RegionEhemaligenverein::Treasurer)
        * Mitglied Ehemalige: [:group_read]  --  (Group::RegionEhemaligenverein::NejbMember)
        * Neumitglied: []  --  (Group::RegionEhemaligenverein::NejbJoiner)
        * Extern: []  --  (Group::RegionEhemaligenverein::External)
        * Versandadresse: []  --  (Group::RegionEhemaligenverein::DispatchAddress)
    * Ehemaligenverein (Schar)
      * Ehemaligenverein (Schar)
        * Leitung: [:layer_full, :contact_data]  --  (Group::NejbSchar::Leader)
        * Adressverwaltung: [:layer_full]  --  (Group::NejbSchar::GroupAdmin)
        * Kassier*in: [:layer_read]  --  (Group::NejbSchar::Treasurer)
        * Mitglied Ehemalige: [:group_read]  --  (Group::NejbSchar::NejbMember)
        * Neumitglied: []  --  (Group::NejbSchar::NejbJoiner)
        * Extern: []  --  (Group::NejbSchar::External)
        * Versandadresse: []  --  (Group::NejbSchar::DispatchAddress)
    * Global
      * Einfache Gruppe
        * Leitung: [:group_full]  --  (Group::SimpleGroup::Leader)
        * Mitglied: [:group_read]  --  (Group::SimpleGroup::Member)
        * Adressverwaltung: [:group_full]  --  (Group::SimpleGroup::GroupAdmin)
        * Austritt: [:group_read]  --  (Group::SimpleGroup::Alumnus)
        * Extern: []  --  (Group::SimpleGroup::External)
        * Versandadresse: []  --  (Group::SimpleGroup::DispatchAddress)
      * Einfache Gruppe (Ehemalige)
        * Leitung: [:group_full]  --  (Group::NejbSimpleGroup::Leader)
        * Mitglied Ehemalige: [:group_read]  --  (Group::NejbSimpleGroup::Member)
        * Adressverwaltung: [:group_full]  --  (Group::NejbSimpleGroup::GroupAdmin)
        * Extern: []  --  (Group::NejbSimpleGroup::External)
        * Versandadresse: []  --  (Group::NejbSimpleGroup::DispatchAddress)
        * Neumitglied: []  --  (Group::NejbSimpleGroup::NewJoiner)

(Output of rake app:hitobito:roles)
<!-- roles:end -->
