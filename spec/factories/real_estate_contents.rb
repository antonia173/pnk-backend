FactoryBot.define do
  factory :real_estate_content do
    sequence(:name)   { |n| "Content #{n}" }
    description { 'Some Description' } 
    quantity { 1 } 
    real_estate 
  end
end