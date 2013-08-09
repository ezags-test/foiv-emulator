# encoding: utf-8

class PriorityCollectionInput < SimpleForm::Inputs::CollectionSelectInput
  self.default_options = { include_blank: false,
                           input_html:    { class: 'input-xxlarge' } }

  def input
    @collection = sort_by_priority(collection, options.delete(:priority))
    super
  end

  def sort_by_priority(collection, ids)
    collection.sort_by { |c| ids.index(c.id) || Float::INFINITY }
  end
end
