FactoryGirl.define do
  sequence :name do |n|
    "Foo bar #{n}"
  end

  sequence :email do |n|
    "person#{n}@example.com"
  end

  sequence :uid do |n|
    "#{n}"
  end

  factory :user do |f|
    f.name "Foo bar"
    f.password "123456"
    f.email { generate(:email) }
  end

  factory :company do |f|
    user
    f.name { generate(:name) }
    f.code "fb"
  end

  factory :gift_card do |f|
    user
    company
    code { generate(:uid) }
    f.value 25000
    f.state "pending"
  end
end