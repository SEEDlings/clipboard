Rails.application.config.middleware.use OmniAuth::Builder do
  provider :salesforcesandbox, ENV['SALESFORCE_SANDBOX_KEY'], ENV['SALESFORCE_SANDBOX_SECRET']
end