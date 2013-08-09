class BirthFilter < ActRecordFilter
  has_person :father
  has_person :mother
  has_person :child

  def column_for_attribute(name)
    if respond_to?(name)
      ActiveRecord::ConnectionAdapters::Column.new(name, '')
    end
  end
end
