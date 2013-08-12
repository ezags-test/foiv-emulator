class BirthRequest < Ezags

  class << self
    def begin_search(params)
      Thread.new(params) do |params|

         request = BuildRequest.new('search_filter_birth', params)
         ticket  = send_filter(request.render)
         return unless ticket

         i=0
         sleep 10
         loop do
           i+=1
           request = BuildRequest.new('get_act_record_birth', { ticket: ticket })
           result = get_result(request.render)

           WebsocketRails[:response].trigger(:updated, result)

           break if finished?(result[:status]) || i==3
           sleep 5
         end

      end
    end


    def parse_result(response)
      result = response.first.last['Body']['actRecordBirthResponse']['MessageData']['AppData']['actRecordBirthResponseObj']
      if result
        params = {
          status: result['status'],
          resultSearch: result['resultSearch'],
          actRecordStatus: result['actRecordStatus'],
          errorSearchDescription: result['errorSearchDescription']
        }

        if result['signedActRecordBirth']
          act_record = result['signedActRecordBirth']

          params[:actRecordUID] = act_record['actRecord']['actRecordUID']
          params[:zagsSignature] =  act_record['actRecordSignature']['Signature'].to_xml(root: 'Signature')
          params[:smevSignature] =  response.first.last['Header']['Security']['Signature'].to_xml(root: 'Signature')
        elsif result['actRecordUID']
          params[:actRecordUID] = result['actRecordUID']
        end
      else
        { status: 'fault' }
      end

      params
    end

    def parse_ticket(response)
      response.first.last['Body']['ticketNumberResponse']['MessageData']['AppData']['ticketNumberObj']['return'] rescue nil
    end
  end

  def request_type(response)
    case
    when response.first.last['Body']['actRecordBirthResponse']
      'ticketSearchPersonalActRecordBirthRequest'
    when response.first.last['Body']['ticketNumberResponse']
      'actRecordBirthFilterRequest'
    else
      'Fault'
    end
  end

  def finished?(status)
      status.in? ['processed','refuse','timeout','fault']
  end
end