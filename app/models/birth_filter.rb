class BirthFilter < ActRecordFilter
  has_person :father
  has_person :mother
  has_person :child
end
