require 'spec_helper'

RSpec.describe PeepConn::Export do
  before(:each) do
    @exporter = PeepConn::Export.new(TestAssets::Constants::CONFIG)
  end

  it 'has an exporter instance' do
    expect(@exporter).to be_a PeepConn::Export
  end

  describe '#template_columns_for' do
    before(:each) do
      @user_cols = 'name,reference,first_name,last_name,phone,mobile,email'
    end

    it 'should return template columns for a PeopleVox table' do
      type = 'Customers'
      expect(@exporter.template_columns_for(type)).to eq @user_cols
    end

    it 'should return template columns from a Spree class name ' do
      type = 'user'
      expect(@exporter.template_columns_for(type)).to eq @user_cols
    end

    it 'should return custom headers if provided' do
      type = 'Customers'
      custom_headers = 'test,headers'
      expect(@exporter.template_columns_for(type, custom_headers)).to eq custom_headers
    end
  end

  describe '#export' do
    it 'should export an instances CSV to PeopleVox' do
      data = {
        type: 'user',
        csv: 'test-name,test-ref,test-first,test-last,test-phone,test-mob,test-email'
      }
      res = @exporter.export(data).body
      expect(res[:save_data_response][:save_data_result][:response_id]).to eq '0'
      expect(res[:save_data_response][:save_data_result][:total_count]).to eq '1'
      expect(res[:save_data_response][:save_data_result][:statuses][:integration_status_response][:status]).to eq 'Success'
    end

    it 'should export specified columns to PeopleVox' do
      data = { type: 'user', csv: 'test-ref,test-name2' }
      custom_headers = 'reference,name'
      res = @exporter.export(data, custom_headers).body
      expect(res[:save_data_response][:save_data_result][:response_id]).to eq '0'
      expect(res[:save_data_response][:save_data_result][:total_count]).to eq '1'
      expect(res[:save_data_response][:save_data_result][:statuses][:integration_status_response][:status]).to eq 'Success'
    end
  end
end
