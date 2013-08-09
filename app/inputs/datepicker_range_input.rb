class DatepickerRangeInput < AddonInput
  alias_method :origin_attribute_name, :attribute_name

  def input_html_options
    super.merge({ 'data-provide' => 'datepicker', 'data-date-format' => 'dd.mm.yyyy', 'data-date-language' => 'ru' })
  end

  def attribute_name
    attribute_name_left
  end

  def attribute_name_left
    "#{origin_attribute_name}_greater_than_or_equal_to"
  end

  def attribute_name_right
    "#{origin_attribute_name}_less_than_or_equal_to"
  end

  def left_input_html_options
    input_html_options.merge(class: left_input_html_classes)
  end

  def left_input_html_classes
    input_html_classes + ["left"]
  end

  def right_input_html_options
    input_html_options.merge(class: right_input_html_classes)
  end

  def right_input_html_classes
    input_html_classes + ["right"]
  end

  def left_part
    template.content_tag(:span, "#{I18n.t('meta_search.from')} ", class: 'add-on') <<  @builder.text_field(attribute_name_left, left_input_html_options)
  end

  def right_part
    template.content_tag(:span, " #{I18n.t('meta_search.to')} ", class: 'add-on') << @builder.text_field(attribute_name_right, right_input_html_options)
  end

  def render_input
    left_part << right_part
  end
end
