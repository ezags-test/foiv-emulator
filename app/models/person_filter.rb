module PersonFilter
  extend ActiveSupport::Concern

  included do
    include ActiveAttr::Model unless include?(ActiveAttr::Model)
  end

  PERSON_ATTRIBUTES      = %w(last_name first_name middle_name gender snils)
  BIRTH_DATES_ATTRIBUTES = %w(birth_date birth_period_from birth_period_to birth_period_from_day birth_period_from_month birth_period_from_year birth_period_to_day birth_period_to_month birth_period_to_year)
  BIRTH_PLACE_ATTRIBUTES = %w(birth_place_kladr_code birth_place_fias_code birth_place_raw_address)
  ATTRIBUTES             = PERSON_ATTRIBUTES + BIRTH_DATES_ATTRIBUTES + BIRTH_PLACE_ATTRIBUTES

  module ClassMethods
    def attributes_for(kind, &block)
      if block_given?
        ATTRIBUTES.each { |attr| block.call "#{kind}_#{attr}" }
      else
        ATTRIBUTES.map { |attr| "#{kind}_#{attr}" }
      end
    end

    def has_person(kind)
      attr_accessor :"#{kind}_birth_period"

      ATTRIBUTES.each do |attr|
        attribute "#{kind}_#{attr}" # father_last_name
      end
    end
  end

  extend ClassMethods
end
