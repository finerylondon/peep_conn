require 'spec_helper'

RSpec.describe PeepConn::Subscription do
  before(:each) do
    config =
      { client_id: 'lfg9938',
        username: 'steve',
        url: 'https://wms.peoplevox.net/lfg9938/resources/integrationservicev4.asmx?wsdl',
        callback_base: 'https://ac720e04.ngrok.io',
        paths: {
          peoplevox_availability: '/peoplevox/availability',
          peoplevox_status_change: '/peoplevox/status_change',
          peoplevox_goods_received: '/peoplevox/goods_received',
          peoplevox_tracking_received: '/peoplevox/tracking_received',
          peoplevox_incremental_change: '/peoplevox/incremental_change'
        } }
    @subscription = PeepConn::Subscription.new(config)
  end

  it 'should be able to create and remove a subscription' do
    res = @subscription.register_availability.body
    expect(res[:subscribe_event_response][:subscribe_event_result][:response_id]).to eq '0'
    new_sub = res[:subscribe_event_response][:subscribe_event_result][:detail]
    expect(new_sub.to_i).to be > 0

    res = @subscription.unsubscribe(new_sub).body
    expect(res[:unsubscribe_event_response][:unsubscribe_event_result][:response_id]).to eq '0'
    expect(res[:unsubscribe_event_response][:unsubscribe_event_result][:detail]).to eq 'True'
  end
end
