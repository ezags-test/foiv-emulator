class Glossary
  def self.get(name)
    const_get name.camelize
  end

  def initialize(table)
    @by_label = {}
    @by_value = {}
    table.each do |value, label|
      @by_value[value] = label
      @by_label[label] = value
    end
  end

  def label(value)
    @by_value[value] || @by_value[value.to_s]
  end

  def value(label)
    @by_label[label] || @by_label[label.to_s]
  end

  def values
    @by_value.keys
  end

  def labels
    @by_label.keys
  end

  def for_select
    @by_label
  end

  def to_hash
    @by_value
  end

  def for_autocomplete
    by_value_for_autocomplete = {}
    @by_value.each do |element|
      if element[0] === true
        element[0] = 1
      elsif element[0] === false
        element[0] = 0
      end
      by_value_for_autocomplete[element[0]] = element[1]
    end
    by_value_for_autocomplete.to_json
  end
end
