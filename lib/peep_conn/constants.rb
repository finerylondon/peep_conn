module PeepConn
  VERSION = '0.0.2'.freeze

  # Link our instance with applicable PeopleVox table
  # Update: additional tables added not linked to instances, but following
  # the same singular resource name
  TABLE_NAMES = { 'carrier' => 'Carriers',
                  'address' => 'Customer addresses',
                  'user' => 'Customers',
                  'dispatch_package' => 'Despatch packages',
                  'dispatch' => 'Despatches',
                  'item_type_group' => 'Item type groups',
                  'item_type_kitting' => 'Item type kittings',
                  'line_item_supplier' => 'Item type suppliers',
                  'item_type_unit' => 'Item type units',
                  'location_group_type' => 'Location group types',
                  'product' => 'Item types',
                  'location_group' => 'Location groups',
                  'location' => 'Locations',
                  'package_type' => 'Package types',
                  'payment_method' => 'Payment methods',
                  'purchase_order_item' => 'Purchase order items',
                  'purchase_order' => 'Purchase orders',
                  'removal' => 'Removals',
                  'return_reason' => 'Return reasons',
                  # 'return' => 'Returns', # Currently broken in PV, can't configure
                  'role' => 'Roles',
                  'line_item' => 'Sales order items',
                  'order' => 'Sales orders',
                  'service_type' => 'Service types',
                  'site' => 'Sites',
                  'supplier_address' => 'Supplier addresses',
                  'supplier' => 'Suppliers',
                  'tax_code' => 'Tax codes',
                  'unit_type' => 'Unit types' }.freeze
end
