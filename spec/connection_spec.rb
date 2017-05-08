require 'spec_helper'

RSpec.describe PeepConn::Connection do
  before(:each) do
    @connection = PeepConn::Connection.new(TestAssets::Constants::CONFIG)
  end

  it 'has access to table name constants' do
    expect(PeepConn::TABLE_NAMES).not_to be nil
  end

  describe '#retrieve_session' do
    it 'returns a session on the first request' do
      res = @connection.send(:retrieve_session)
      expect(res).to be_a Hash
      expect(res.count).to be 2
      expect(res.keys).to include :client_id, :session_id
    end
  end

  describe '#connection' do
    it 'connects to the PeopleVox WSDL' do
      client = @connection.send(:client)
      expect(
        client.instance_variable_get('@wsdl').instance_variable_get('@document')
      ).to eq 'https://wms.peoplevox.net/lfg9938/resources/integrationservicev4.asmx?wsdl'
    end
  end

  describe '#table_from' do
    before(:each) { @conn ||= PeepConn::Connection.new({}) }
    it 'returns the PeopleVox table name from a Spree one' do
      expect(@conn.send(:table_from, 'user')).to eq 'Customers'
    end

    it 'accepts a PeopleVox table name' do
      expect(@conn.send(:table_from, 'Customers')).to eq 'Customers'
    end
  end

  describe '#savon_globals' do
    it 'only provides session headers if requested' do
      without_session = @connection.send(:savon_globals, false)
      expect(without_session.keys).to_not include :soap_header
    end
  end
end
