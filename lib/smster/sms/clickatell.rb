class Sms::Clickatell < SmsLayer
  attr_accessor :unicode

  private

    def modify_params
      self.to = to.gsub(/\D/, '').to_s
      self.text = text.tr(' ', '+')
    end

    def send_request
      msg_params = {
        'text' => text,
        'to' => [to],
        'unicode' => unicode,
        'from' => name
      }.to_json

      code = config.clickatell_authorization_code

      start_request(msg_params, code)
    end

    def start_request(params, code)
      RestClient.post(
        'https://api.clickatell.com/rest/message',
        params,
        content_type: :json,
        accept: :json,
        'X-Version' => 1,
        'Authorization' => "bearer #{code}"
      )
    rescue => e
      e.response
    end

    def assign_attrs_by(response)
      response = JSON.parse(response)

      info = response['data']['message'][0]

      self.status_message = info['error']
      self.api_message_id = info['apiMessageId']
    end
end
