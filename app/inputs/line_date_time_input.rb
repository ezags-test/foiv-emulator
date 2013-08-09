# encoding: utf-8
class LineDateTimeInput < LineDateInput
  include ActionView::Helpers::FormTagHelper

  def input
    [ super, at, time ].join(' ')
  end

  private

  def at
    content_tag(:b, content_tag(:span, 'в'))
  end

  def time
    time_options = options.merge({ as: :time })
    @builder.input_field :birth_time, time_options
  end

end
