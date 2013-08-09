class ActRecordFilter
  include MetaFilter
  include PersonFilter

  attribute :act_record_number
  attribute :register_date

  attribute :register_period_from
  attribute :register_period_from_day
  attribute :register_period_from_month
  attribute :register_period_from_year

  attribute :register_period_to
  attribute :register_period_to_day
  attribute :register_period_to_month
  attribute :register_period_to_year

  attribute :registrar_id
  attribute :registrar_name
end
