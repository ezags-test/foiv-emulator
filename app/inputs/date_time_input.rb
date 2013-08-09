# encoding: utf-8
class DateTimeInput < SimpleForm::Inputs::DateTimeInput
  def initialize(*)
    super
    @input_html_classes << 'input-mini'
  end
end
