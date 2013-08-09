class DatepickerInput < AddonInput

  def input_html_options
    super.merge({ 'data-provide' => 'datepicker', 'data-date-format' => 'dd.mm.yyyy', 'data-date-language' => 'ru' })
  end

  def render_input
    input_html_options[:value] = I18n.localize(value) rescue nil
    @builder.text_field(attribute_name, input_html_options)
  end

  def value
    options[:value] || input_html_options[:value] || object.send(reflection_or_attribute_name)
  rescue
    ""
  end

end
