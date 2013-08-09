# encoding: utf-8
class NationalityInput < AjaxAutocompleteInput
  def source
    "/autocomplete/select_nationality/?query=%query%&gender=#{object.gender}"
  end
end
