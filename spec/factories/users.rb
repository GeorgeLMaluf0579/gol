FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'p@$$w0rd' }
    password_confirmation { 'p@$$w0rd' }
  end
end
