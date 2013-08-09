class BaseNameInput < SimpleForm::Inputs::StringInput

  def input_html_options
    defaults = {
      'typeahead-name' => typeahead_name_options,
    }
    defaults.merge super || {}
  end

  def search_collection
    raise NotImplementedError
  end

  def typeahead_name_options
    {
      source: "#{Settings.urls.search.names}/#{search_collection}/_search",
      search_params: search_params
    }.to_json
  end

  def search_params
    {
      query: {
        queryString: {
          fields: ['name', 'name_en', 'name_translit'],
          default_operator: 'and',
          analyze_wildcard: true
        }
      },
      sort: ['_score', 'weight'],
      filter: {
        range: {
          gender: { from: gender_index, to: gender_index }
        }
      }
    }
  end

  def gender_index
    if object.respond_to?(:gender)
      case object.gender
      when true
        1
      when false
        0
      end
    end
  end
end
