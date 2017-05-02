require 'savon'
require 'active_support/core_ext/object'

module PeepConn
  class Connection
    attr_accessor :config

    # Link our instance with applicable PeopleVox table
    TABLE_NAMES = {
      'user' => 'Customers',
      'address' => 'Customer addresses',
      'order' => 'Sales orders',
      'line_item' => 'Sales order items'
    }.freeze

    def initialize(config)
      # TODO: move config to initializer, PEEP_CONF for Dev use
      # @config = config
      @config ||= PeepConn::PEEP_CONF

      # Lists all the operations available via PeopleVox
      # puts client.operations
    end

    private

    def client
      @client ||= Savon.client(savon_globals(true, :client_id, :session_id))
    end

    def unauthorized_client
      @unauthorized_client ||= Savon.client(savon_globals(false, :password))
    end

    def session
      return @session if @session

      response = unauthorized_client.call(
        :authenticate, message: { clientId: config[:client_id],
                                  username: config[:username],
                                  password: Base64.encode64(ENV['PV_PASS']) }
      ).body
      session_string = response.try(:[], :authenticate_response).try(:[], :authenticate_result).try(:[], :detail)
      session_array = session_string.try(:split, ',')
      @session ||= { client_id: session_array.first,
                     session_id: session_array.last }
    end

    def reset_session
      # TODO: implement this whenever a session has expired
      @unauthorized_client = nil
      @client = nil
      @session = nil
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
                         ClientId: session[:client_id],
                         SessionId: session[:session_id]
                       }
                     })
    end

    def table_from(type)
      TABLE_NAMES[type]
    end
  end
end
