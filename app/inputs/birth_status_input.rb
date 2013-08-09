# encoding: utf-8
class BirthStatusInput < GlossaryAutocompleteInput
  def glossary
    Glossary::BIRTH_STATUS
  end
end
