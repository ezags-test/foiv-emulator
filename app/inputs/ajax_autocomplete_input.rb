# encoding: utf-8
class AjaxAutocompleteInput < AbstractAutocompleteInput
  include ActionView::Helpers::FormTagHelper

  def label_input_value
    @reflection.klass.find(input_value).send(@reflection.klass.autocomplete_label_column_name) if input_value
  end
end
