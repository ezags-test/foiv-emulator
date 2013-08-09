class FioInput < SimpleForm::Inputs::Base
  def input
    input_html_options[:wrapper] = false

    surname    = input_field :last_name
    first_name = input_field :first_name
    patronymic = input_field :middle_name

    [surname, first_name, patronymic].join(' ')
  end

  def input_field(input)
    input_name = kind ? "#{kind}_#{input}" : input
    @builder.input_field input_name, placeholder: I18n.t(input, scope: 'simple_form.placeholders.defaults')
  end

  def kind
    options[:kind]
  end
end
