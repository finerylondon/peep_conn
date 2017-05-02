module PeepConn
  class Subscription < Connection
    # Needs an open ngrok channel in peoplevox.yml - these subs need clearing
    # and re-adding whenever this changes

    EVENT_TYPES = { peoplevox_availability: 'AvailabilityChanges',
                    peoplevox_status_change: 'SalesOrderStatusChanges',
                    peoplevox_goods_received: 'GoodsReceived',
                    peoplevox_tracking_received: 'TrackingNumberReceived',
                    peoplevox_incremental_change: 'IncrementalChanges' }.freeze

    def refresh_subscriptions
      # Will work until there are > 100 previous subscriptions
      (1..100).each { |n| unsubscribe n }
      register_availability
      register_order_status_change
      register_goods_received
      register_tracking_received
      register_incremental_change
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

    def register_goods_received
      params = { id: '{GoodsInId}',
                 references: '{Reference}',
                 time: '{ReconciledDateTime}',
                 quantity: '{Consignments.ConsignmentItemTypes.Quantity}',
                 items: '{Consignments.ConsignmentItemTypes.ItemType.Name}',
                 skus: '{Consignments.ConsignmentItemTypes.ItemType.ItemCode}' }
      register(:peoplevox_goods_received, params)
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

    def register_incremental_change
      params = { quantity: '{QuantityChanged}',
                 updated_by: '{UpdatedBy}',
                 updated_at: '{UpdateTimestamp}',
                 reason: '{Reason}',
                 product_name: '{ItemType.Name}',
                 product_sku: '{ItemType.ItemCode}' }
      register(:peoplevox_incremental_change, params)
    end

    def register(type, params)
      sub_url = url_builder(type, params)

      client.call(:subscribe_event, message: { eventType: EVENT_TYPES[type],
                                               callbackUrl: sub_url })
    end

    def unsubscribe(sub_id)
      client.call(:unsubscribe_event, message: { subscriptionId: sub_id })
    end

    def query_string_from(values)
      values.reduce('?') { |a, (k, v)| a.tap { |str| str << "#{k}=#{v}&" } }.chop
    end

    def url_builder(path, values)
      "#{base_url}#{config[:paths][type]}#{query_string_from(values)}"
    end

    def base_url
      config[:callback_base]
    end
  end
end
