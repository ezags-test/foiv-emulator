# encoding: utf-8
class AbstractAutocompleteInput < SimpleForm::Inputs::StringInput
  include ActionView::Helpers::FormTagHelper

  def input
    super + label_input
  end

  def input_html_options
    super.merge type: :hidden
  end

  def label_input
    text_field_tag nil, label_input_value, label_input_html_options
  end

  def label_input_html_options
    {
      data: {
        provide: 'autocomplete',
        source: source
      },
      class: 'input-xxlarge'
    }
  end

  def label_input_value
    # init value for label input
  end

  def source
    # hash json or url
  end

  def input_value
    @input_value ||= object.send attribute_name
  end
end
