module PeepConn
  class Subscription < Connection
    # Needs an open ngrok channel in passed config for dev -
    # these subs need clearing and re-adding whenever this changes

    EVENT_TYPES = {
      peoplevox_availability: 'AvailabilityChanges',
      peoplevox_status_change: 'SalesOrderStatusChanges',
      peoplevox_tracking_received: 'TrackingNumberReceived'
    }.freeze

    def refresh_subscriptions
      # Will work until there are > 100 previous subscriptions
      (50..150).each { |n| unsubscribe n }
      register_availability
      register_order_status_change
      register_tracking_received
    end

    def register_availability
      params = { sku: '{ItemCode}',
                 quantity: '{Available}' }
      register(:peoplevox_availability, params)
    end

    def register_order_status_change
      params = { time: '{LastModificationTime}',
                 order_no: '{SalesOrderNumber}',
                 status: '{SalesOrderStatu.Name}' }
      register(:peoplevox_status_change, params)
    end

    def register_tracking_received
      params = { dispatch_number: '{DespatchNumber}', # <- Note spelling
                 tracking_number: '{TrackingNumber}',
                 carrier: '{Carrier.Number}',
                 service_name: '{ServiceType.Name}',
                 service_code: '{ServiceType.Code}',
                 order_number: '{Picks.SalesOrder.SalesOrderNumber}',
                 order_email: '{Picks.SalesOrder.Email}' }
      register(:peoplevox_tracking_received, params)
    end

    def register(type, params)
      sub_url = url_builder(type, params)

      client.call(:subscribe_event, message: { eventType: EVENT_TYPES[type],
                                               filter: 'site == "PrimarySite"',
                                               callbackUrl: sub_url })
    end

    def unsubscribe(sub_id)
      client.call(:unsubscribe_event, message: { subscriptionId: sub_id })
    end

    def query_string_from(values)
      values.reduce('?') { |a, (k, v)| a.tap { |str| str << "#{k}=#{v}&" } }.chop
    end

    def url_builder(type, values)
      "#{base_url}#{config[:paths][type]}#{query_string_from(values)}"
    end

    def base_url
      config[:callback_base]
    end
  end
end
