require 'test_assets/password'

module TestAssets
  module Constants
    CONFIG = {
      client_id: 'lfg9938',
      username: 'steve',
      url: 'https://wms.peoplevox.net/lfg9938/resources/integrationservicev4.asmx?wsdl',
      callback_base: 'https://ac720e04.ngrok.io',
      password: TestAssets::Password::PASSWORD,
      paths: {
        peoplevox_availability: '/peoplevox/availability',
        peoplevox_status_change: '/peoplevox/status_change',
        peoplevox_goods_received: '/peoplevox/goods_received',
        peoplevox_tracking_received: '/peoplevox/tracking_received',
        peoplevox_incremental_change: '/peoplevox/incremental_change'
      }
    }.freeze
  end
end
