module PeepConn
  class Query < Connection
    def retrieve(table, opts = {})
      # Retrieves data from a table, with opts
      client.call(
        :get_data, message: { getRequest: { ItemsPerPage: opts[:per_page] || 0,
                                            PageNo: opts[:page] || 1,
                                            SearchClause: opts[:term] || '',
                                            TemplateName: table } }
      ).body
    end
  end
end
