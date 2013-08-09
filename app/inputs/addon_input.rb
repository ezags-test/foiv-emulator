class AddonInput < SimpleForm::Inputs::BlockInput
  enable :placeholder, :maxlength, :pattern
  self.default_options = { input_html: { class: 'input-with-addon input-small' } }

  def input
    add_size!
    if options[:wrapper] == :append
      render_input << add_on
    elsif options[:label] == false
      add_on << render_input
    else
      render_input
    end
  end

  def render_input
    @builder.text_field(attribute_name, input_html_options)
  end

  def add_on
    @builder.label(attribute_name, label_text, label_html_options)

  end

  def label_html_options
    if options[:label] == false
      options = super
      classes = "add-on"
      options[:class] << classes
      options
    else
      super
    end
  end

end