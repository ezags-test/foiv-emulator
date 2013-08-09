module ArbitraryAutocompleteInput

  def label_input_value
    super || object.send(label_attribute_name)
  end

  def label_input_html_options
    super.deep_merge name: label_input_name, data: { arbitrary: true }
  end

  def label_input_name
    "#{object_name}[#{label_attribute_name}]"
  end

  def label_attribute_name
    @label_attribute_name ||= attribute_name.to_s.gsub(/_id$/, '_name')
  end

end
