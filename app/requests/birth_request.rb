class BirthRequest < Ezags

  class << self
    def begin_search(params)
       request = BuildRequest.new('search_filter_birth', params)
       ticket  = send_filter(request.render)
       return unless ticket
       i=0
       sleep 10
       loop do
         i+=1
         request = BuildRequest.new('get_act_record_birth', { ticket: ticket })
         result = get_result(request.render)
         break if result[:status] == 'processed' || i==3
         sleep 5
       end
    end


    def parse_result(response)
      result = response.first.last['Body']['actRecordBirthResponse']['MessageData']['AppData']['actRecordBirthResponseObj']
      if result
        params = {
          status: result['status'],
          resultStatus: result['resultSearch'],
          actRecordStatus: result['actRecordStatus'],
          errorSearchDescription: result['errorSearchDescription']
        }

        if result['signedActRecordBirth']
          params[:act_record_uid] = result['signedActRecordBirth']['actRecord']['actRecordUID']
        elsif result['actRecordUID']
          params[:act_record_uid] = result['actRecordUID']
        end
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
end