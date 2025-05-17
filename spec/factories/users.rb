FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:username) { |n| "user#{n}" }
    password { 'password123' }
    first_name { 'John' }
    last_name { 'Doe' }
    role { :user }
    status { :active }
    confirmed { false }

    trait :admin do
      role { :admin }
    end

    trait :superadmin do
      role { :superadmin }
    end

    trait :blocked do
      status { :blocked }
    end

    trait :inactive do
      status { :inactive }
    end

    trait :verified do
      confirmed { true }
    end
  end
end
