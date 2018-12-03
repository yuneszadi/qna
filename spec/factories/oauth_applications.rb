FactoryBot.define do
  factory :oauth_application, class: Doorkeeper::Application do
    name { 'Test'}
    redirect_uri { 'urn:ietf:wg:oauth:2.0:oob' }
    uid { rand(123456) }
    secret { rand(654321) }
  end
end
