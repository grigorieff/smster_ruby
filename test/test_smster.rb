require 'minitest/autorun'
require 'webmock/minitest'
require 'smster'

class SmsterTest < Minitest::Test
  def test_should_send
    stub_send_request

    @statuses = Sms::STATUSES
    phone = (99_999_999 * rand).to_s
    attrs = { to: phone, text: 'i am smster!' }

    sms = Sms::Smsru.new(attrs)
    sms.send_sms

    assert_equal @statuses[:sent], sms.status
  end

  private

    def stub_send_request
      stub_request(:post, 'http://sms.ru/sms/send')
        .to_return(
          status: 200,
          body:
            '100
            201523-1000007
            balance=52.54',
          headers: {}
        )
    end
end
