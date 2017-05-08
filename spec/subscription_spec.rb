require 'spec_helper'

RSpec.describe PeepConn::Subscription do
  before(:each) do
    @subscription = PeepConn::Subscription.new(TestAssets::Constants::CONFIG)
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
