module PeepConn
  VERSION = '0.0.1'.freeze

  # Link our instance with applicable PeopleVox table
  TABLE_NAMES = {
    'user' => 'Customers',
    'address' => 'Customer addresses',
    'order' => 'Sales orders',
    'line_item' => 'Sales order items'
  }.freeze
end
