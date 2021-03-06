require './test/test_helper'

class SmsruTest < Minitest::Test
  def setup
    super

    stub_cost_request
  end

  def test_should_send
    sms = Sms::Smsru.send_sms(to: @to, text: @text)

    assert_equal @statuses[:sent], sms.status
  end

  def test_assign_balance
    sms = Sms::Smsru.send_sms(to: @to, text: @text)

    assert_equal sms.balance, '52.54'
  end

  def test_calc_cost
    sms = Sms::Smsru.new(to: @to, text: @text)

    assert_equal sms.calc_cost, '0.69'
  end

  def test_should_modify_to
    to = 'a+bc' + @to

    sms = Sms::Smsru.send_sms(to: to, text: @text)

    result = to.gsub(/\D/, '')
    assert_equal result, sms.to
  end

  private

    def stub_send_request
      body = "100\n201523-1000007\nbalance=52.54"

      stub_request(:post, 'http://sms.ru/sms/send')
        .to_return(status: 200, body: body, headers: {})
    end

    def stub_cost_request
      body = "100\n0.69\n1"

      stub_request(:post, 'http://sms.ru/sms/cost')
        .to_return(status: 200, body: body, headers: {})
    end
end
