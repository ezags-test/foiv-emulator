# encoding: utf-8
class GlossaryAutocompleteInput < AbstractAutocompleteInput
  include ActionView::Helpers::FormTagHelper

  def source
    glossary.for_autocomplete
  end

  def label_input_value
    glossary.label(input_value) if input_value
  end
end
