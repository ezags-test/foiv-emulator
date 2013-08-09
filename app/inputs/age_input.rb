# encoding: utf-8
class AgeInput < SimpleForm::Inputs::Base
  def input
    buffer = 'исполнилось '
    buffer << @builder.input_field(attribute_name, input_html_options)
    buffer << ' лет'
    buffer
  end
end
