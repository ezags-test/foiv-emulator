class TypeaheadInput < SimpleForm::Inputs::StringInput
  self.default_options.deep_merge! input_html: {
    autocomplete: 'off',
    data: {
      provide: 'typeahead',
      source: "#{Settings.services.enquiry.endpoint}/surnames/%query%"
    }
  }
end
