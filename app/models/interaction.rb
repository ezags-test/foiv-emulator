class Interaction < ActiveRecord::Base
  attr_accessible :request, :response, :request_type, :url
end
