class CheckBoxInput < AddonInput

  def render_input
    @builder.check_box(attribute_name, input_html_options)
  end

  def label_text
    input_html_options[:label_text] || super
  end

end