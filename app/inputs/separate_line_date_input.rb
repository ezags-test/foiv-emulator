class SeparateLineDateInput < LineDateInput
  def input
    [ day, month, year ].join(' ')
  end

  def day
    name  = [ attribute_name, 'day' ].join('_')
    super(name, value(name))
  end

  def month
    name = [ attribute_name, 'month' ].join('_')

    a = @builder.text_field(name, { value: value(name), type: :hidden })
    b = template.text_field_tag nil, nil, month_html_options

    a + b
  end

  def year
    name = [ attribute_name, 'year' ].join('_')
    super(name, value(name))
  end

  private

  def value(name)
    object.send(name)
  end
end
