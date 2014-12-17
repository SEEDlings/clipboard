Rails.application.config.middleware.use OmniAuth::Builder do
  provider :salesforcesandbox, ENV['SALESFORCE_KEY'], ENV['SALESFORCE_SECRET']
  provider :salesforce, ENV['SALESFORCE_KEY'], ENV['SALESFORCE_SECRET']
end