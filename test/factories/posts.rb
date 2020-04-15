FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    published { [false, true].sample }
    factory :published_post do
      published { true }
    end
    user # hace referencia al factory user
  end

end
