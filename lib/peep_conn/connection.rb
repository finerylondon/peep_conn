require 'savon'
require 'active_support/core_ext/object'

module PeepConn
  class Connection
    # Initiates connection to PeopleVox. All query classes are subclasses of this,
    # inheriting :initialize to setup the config.
    attr_accessor :config

    def initialize(config)
      @config = config
    end

    private

    def client
      retrieve_session
      @client ||= Savon.client(savon_globals(true, :client_id, :session_id))
      @client.http.send_timeout    = 300
      @client.http.receive_timeout = 300
      puts @client.operations.inspect
      @client
    end

    def unauthorized_client
      @unauthorized_client ||= Savon.client(savon_globals(false, :password))
    end

    def retrieve_session
      return @session if @session && @session_age.try(:>, 29.minutes.ago)
      reset_session

      response = unauthorized_client.call(
        :authenticate, message: { clientId: config[:client_id],
                                  username: config[:username],
                                  password: Base64.encode64(config[:password]) }
      ).body
      session_string = response.try(:[], :authenticate_response).try(:[], :authenticate_result).try(:[], :detail)
      session_array = session_string.try(:split, ',')
      @session_age = Time.now
      @session = { client_id: session_array.first,
                   session_id: session_array.last }
    end

    def reset_session
      @unauthorized_client = nil
      @client = nil
      @session = nil
      @session_age = nil
    end

    def savon_globals(headers, *filters)
      defaults = { wsdl: config[:url],
                   convert_request_keys_to: :none,
                   filters: filters,
                   pretty_print_xml: true,
                   log: true,
                   logger: Logger.new(STDOUT) }
      return defaults unless headers

      defaults.merge(soap_header: {
                       UserSessionCredentials: {
                         ClientId: @session[:client_id],
                         SessionId: @session[:session_id]
                       }
                     })
    end

    def table_from(type)
      return type if PeepConn::TABLE_NAMES.values.include? type
      PeepConn::TABLE_NAMES[type.downcase]
    end
  end
end
