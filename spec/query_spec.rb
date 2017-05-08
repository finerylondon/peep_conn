require 'spec_helper'

RSpec.describe PeepConn::Query do
  before(:each) do
    @searcher = PeepConn::Query.new(TestAssets::Constants::CONFIG)
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
