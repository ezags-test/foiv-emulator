module PersonFilter
  extend ActiveSupport::Concern

  included do
    include ActiveAttr::Model unless include?(ActiveAttr::Model)
  end

  PERSON_ATTRIBUTES      = %w(last_name first_name middle_name birth_date birth_period gender snils)
  BIRTH_PLACE_ATTRIBUTES = %w(birth_place_kladr_code birth_place_fias_code birth_place_raw_address)
  ATTRIBUTES             = PERSON_ATTRIBUTES + BIRTH_PLACE_ATTRIBUTES

  module ClassMethods
    def attributes_for(kind, &block)
      if block_given?
        ATTRIBUTES.each { |attr| block.call "#{kind}_#{attr}" }
      else
        ATTRIBUTES.map { |attr| "#{kind}_#{attr}" }
      end
    end

    def has_person(kind)
      ATTRIBUTES.each do |attr|
        attribute "#{kind}_#{attr}" # father_last_name
      end
    end
  end

  extend ClassMethods
end
