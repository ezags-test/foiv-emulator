# encoding: utf-8
class RegistrarInput < AjaxAutocompleteInput
  include ArbitraryAutocompleteInput

  def source
    'http://rzags-test.ezags.at-consulting.ru/autocomplete/select_registrar/?query=%query%'
  end

  def label_input_html_options
    super.merge placeholder: 'Введите наименование органа ЗАГС'
  end
end
