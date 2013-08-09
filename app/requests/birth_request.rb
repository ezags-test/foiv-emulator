class BirthRequest < Ezags

  class << self
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