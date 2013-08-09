class LineDateInput < SimpleForm::Inputs::Base
  def input
    if separate?
      input = @builder.send(:find_input, attribute_name, options.merge(as: :separate_line_date))
      SimpleForm::Wrappers::Root.new([:input, :error], wrapper: false).render input
    else
      [ day, month, year ].join(' ')
    end
  end

  private

  def day(name = "#{attribute_name}(3i)", value = value(:day))
    @builder.text_field name, { class: 'input-mini', value: value, placeholder: I18n.t('date.names.day') }
  end

  def month(name = "#{attribute_name}(2i)", value = value(:month))
    a = @builder.text_field name, { value: value, type: :hidden }
    b = template.text_field_tag nil, nil, month_html_options
    a + b
  end

  def year(name = "#{attribute_name}(1i)", value = value(:year))
    @builder.text_field name, { class: 'input-mini', value: value, placeholder: I18n.t('date.names.year') }
  end

  def month_html_options
    {
      data: {
        provide: 'autocomplete',
        source: Glossary::MONTH.for_autocomplete, select: 'next'
      },
      placeholder: I18n.t('date.names.month'), class: 'input-medium'
    }
  end

  def value(name)
    object.send(attribute_name).try(name)
  end

  def separate?
    options[:separate] == true || object.column_for_attribute(attribute_name).nil?
  end
end
