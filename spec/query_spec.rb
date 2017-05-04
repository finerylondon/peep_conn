require 'spec_helper'

RSpec.describe PeepConn::Query do
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
    @searcher = PeepConn::Query.new(config)
  end

  describe '#retrieve' do
    it 'should retrieve all a table\'s data via PeopleVox table name' do
      res = @searcher.retrieve('Customers')
      expect(res[:get_data_response][:get_data_result][:response_id]).to eq '0'
      expect(res[:get_data_response][:get_data_result][:total_count].to_i).to be > 0
    end

    it 'should retrieve all a table\'s data via Spree class name' do
      res = @searcher.retrieve('user')
      expect(res[:get_data_response][:get_data_result][:response_id]).to eq '0'
      expect(res[:get_data_response][:get_data_result][:total_count].to_i).to be > 0
    end

    it 'should be able to retrieve data via a search term' do
      res = @searcher.retrieve('user', term: 'name.StartsWith("test")')
      expect(res[:get_data_response][:get_data_result][:response_id]).to eq '0'
      expect(res[:get_data_response][:get_data_result][:total_count].to_i).to be > 0
    end
  end
end
