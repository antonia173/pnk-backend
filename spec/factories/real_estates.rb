FactoryBot.define do
  factory :real_estate do
    sequence(:name)   { |n| "Real Estate #{n}" }
    price { 100000.00 }
    sequence(:country)   { |n| "Country #{n}" }
    sequence(:city)   { |n| "City #{n}" }
    created_at  { Time.now }

    trait :apartment do
      association :real_estate_type, factory: :real_estate_apartment
    end

    trait :with_contents do
      transient do
        content_count { 2 }
      end

      after(:create) do |real_estate, evaluator|
        create_list(:real_estate_content, evaluator.content_count, real_estate: real_estate)
      end
    end
  end
end