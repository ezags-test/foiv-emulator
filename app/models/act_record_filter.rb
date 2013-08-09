class ActRecordFilter
  include MetaFilter
  include PersonFilter

  attribute :act_record_number
  attribute :register_date
  attribute :register_period_from
  attribute :register_period_to
  attribute :registrar_id
end
