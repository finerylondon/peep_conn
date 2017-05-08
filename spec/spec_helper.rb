require 'bundler/setup'
require 'peep_conn'
require 'test_assets/constants'

# N.B. Tests rely on test_assets/password.rb containing a valid PASSWORD
# constant. This is ignored by git for security.

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
