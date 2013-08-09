# encoding: utf-8
class CitizenshipInput < AjaxAutocompleteInput
  def source
    "/autocomplete/select_citizenship/?query=%query%&gender=#{object.gender}"
  end
end
