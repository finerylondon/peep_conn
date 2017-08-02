module PeepConn
  class Report < Connection
    def retrieve(template, opts = {})
      client.call(
        :get_report_data,
        message: { getReportRequest: {
          TemplateName: template,
          PageNo: opts[:page] || 1,
          ItemsPerPage: opts[:per_page] || 0
        } }
      ).body
    end

    def item_inventory_summary(opts = {})
      client.call(
        :get_report_data,
        message: { getReportRequest: {
          TemplateName: 'Item inventory summary',
          PageNo: opts[:page] || 1,
          ItemsPerPage: opts[:per_page] || 0,
          # Currently pulling all data, as columns / filters aren't working
          # Columns: '[Item code], [Available]',
          # FilterClause: opts[:term] || 'Site reference Equals "PrimarySite"'
        } }
      ).body
    end

    def outstanding_wholesale_orders(opts = {})
      client.call(
        :get_report_data,
        message: { getReportRequest: {
          TemplateName: 'Outstanding sales orders',
          PageNo: opts[:page] || 1,
          ItemsPerPage: opts[:per_page] || 0,
          # Currently pulling all data, as columns / filters aren't working
          # Columns: '[Item code], [Available]',
          # FilterClause: opts[:term] || 'Site reference Equals "Wholesale"'
        } }
      ).body
    end
  end
end
