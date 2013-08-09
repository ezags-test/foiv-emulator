class Ezags
  include HTTParty

  headers 'Content-Type' => 'text/xml;charset=UTF-8'

  base_uri Settings.ezags.url
  format :xml

  def initialize
    @endpoint = Settings.ezags.service.order
  end

  class << self

    def send_filter(body_xml)
      response = new.send body_xml
      parse_ticket(response)
    end

    def get_result(body_xml)
      response = new.send body_xml
      parse_result(response)
    end
  end

  def send(xml)
    response = self.class.post @endpoint, body: xml
    write_log xml, response

    response
  end

  def write_log(request, response)
    attributes ={ url: @endpoint,
                  request_type: request_type(response),
                  request: request,
                  response: response.to_xml }

    Interaction.create(attributes)
  end




end