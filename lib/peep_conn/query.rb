module PeepConn
  class Query < Connection
    def retrieve(table, opts = {})
      # Retrieves data from a table, with opts
      client.call(
        :get_data, message: { getRequest: { ItemsPerPage: opts[:per_page] || 0,
                                            PageNo: opts[:page] || 1,
                                            SearchClause: opts[:term] || '',
                                            TemplateName: table_from(table) } }
      ).body
    end

    def retrieve_with_site_filter(table, opts = {})
      client.call(
        :get_data_with_sites_filters,
        message: { getRequest: { ItemsPerPage: opts[:per_page] || 0,
                                 PageNo: opts[:page] || 1,
                                 SearchClause: opts[:term] || '',
                                 sitesFilter: 'Site.Reference = "PrimarySite"',
                                 TemplateName: table_from(table) } }
      ).body
    end
  end
end
