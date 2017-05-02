module PeepConn
  class Export < Connection
    # takes a hash converted in Rails using 'to_peoplevox', which returns the
    # object's singluar class name as type, and a CSV string of the object's
    # values, i.e. { type: 'person', csv: 'Steve,31,London'}

    def export(data)
      csv = "#{template_columns_for(data[:type])}\n#{data[:csv]}"
      save_data(csv, table_from(data[:type]))
    end

    def template_columns_for(type)
      # Returns the columns setup for a table in PeopleVox - CSV data must
      # correspond to this
      res = client.call(:get_save_template,
                        message: { templateName: table_from(type) })
      headers_from(res.body)
    end

    def headers_from(response_body)
      response_body[:get_save_template_response][:get_save_template_result][:detail]
    end

    def save_data(csv_string, template)
    client.call(:save_data, message: { saveRequest: { TemplateName: template,
                                                      CsvData: csv_string,
                                                      Action: 0 } })
    end
  end
end
