module PeepConn
  VERSION = '0.0.1'.freeze

  # Link our instance with applicable PeopleVox table
  # Update: additional tables added not linked to instances, but following
  # the same singular resource name
  TABLE_NAMES = { 'address' => 'Customer addresses',
                  'user' => 'Customers',
                  'dispatch' => 'Despatches',
                  'line_item_supplier' => 'Item type suppliers',
                  'product' => 'Item types',
                  'location_group' => 'Location groups',
                  'location' => 'Locations',
                  'purchase_order_item' => 'Purchase order items',
                  'purchase_order' => 'Purchase orders',
                  'removal' => 'Removals',
                  'return_reason' => 'Return reasons',
                  'line_item' => 'Sales order items',
                  'order' => 'Sales orders',
                  'supplier' => 'Suppliers',
                  'unit_type' => 'Unit types' }.freeze
end
