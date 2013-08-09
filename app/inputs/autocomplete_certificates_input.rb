class AutocompleteCertificatesInput < SimpleForm::Inputs::StringInput

  def initialize(*)
    super
    input_html_options['data-act-record-type-id'] = object.act_record_type_id
    input_html_options[:value] = options[:blank] ? nil : object.certificates.last.id rescue nil
  end

  def input
    template.content_tag(:div, super, id: "act_record_certificate_id", class: "hidden") << template.content_tag(:div, autocomplete, class: "input-prepend")
  end

  def autocomplete
    serial_part << number_part
  end

  def serial
    unless options[:blank]
      object.certificates.last.serial rescue nil
    end
  end

  def number
    unless options[:blank]
      object.certificates.last.number rescue nil
    end
  end

  def serial_part
    template.content_tag(:span, serial, class: "autocomplete_serial add-on right_p", id: "autocomplete_serial")
  end

  def number_part
    @builder.input_field(attribute_name, input_html_options.merge(number_html_options))
  end

  def number_html_options
    { value:       number,
      placeholder: I18n.t("simple_form.input.value.document_number"),
      type:        "text",
      id:          "autocomplete_certificates",
      name:        "autocomplete_certificates",
      class:       "input-large" }
  end

end
