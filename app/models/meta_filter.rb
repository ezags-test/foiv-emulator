module MetaFilter
  extend ActiveSupport::Concern

  included do
    include ActiveAttr::Model unless include?(ActiveAttr::Model)

    attribute :year_from
    attribute :year_to
  end
end
