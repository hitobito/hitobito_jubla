ThinkingSphinx::Index.define_partial :person do
  indexes name_mother, name_father, nationality, profession, bank_account,
          ahv_number, ahv_number_old, j_s_number, insurance_company, insurance_number
end
