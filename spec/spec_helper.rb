require "paperclip/matchers"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.include Paperclip::Shoulda::Matchers

  config.mock_with :rspec do |mocks|
    mocks.syntax = %i[should receive]
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.before(:each) do
    # Make the default tenant globally available to the tests
    # $default_organization = FactoryBot.create(:organization)
  end

  # config.before(:each) do
  #   if example.metadata[:type] == :request
  #     Set the `test_tenant` value for integration tests
  #     ActsAsTenant.test_tenant = $default_organization
  #   else
  #     Otherwise just use current_tenant
  #     ActsAsTenant.current_tenant = $default_organization
  #   end
  # end

  config.after(:each) do
    # Clear any tenancy that might have been set
    ActsAsTenant.current_tenant = nil
    ActsAsTenant.test_tenant = nil
    User.current_user = nil
  end
end
