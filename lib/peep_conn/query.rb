module PeepConn
  class Query < Connection
    def data(data, term = '')
      # Retrieves data from a table
      # Currently works with template 'Item Types', term 'SiteReference="Lodz"'
      client.call(
        :get_data, message: { getRequest: { ItemsPerPage: 0,
                                            PageNo: 1,
                                            SearchClause: term,
                                            TemplateName: data[:type] } }
      ).body
    end

    def find_in_field(field, term)
      "#{field}.Contains(\"#{term}\")"
    end
  end
end
