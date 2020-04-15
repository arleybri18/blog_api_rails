FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    published { [false, true].sample }
    user # hace referencia al factory user
  end

  factory :published_post, class: 'Post' do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    published { true }
    user # hace referencia al factory user
  end
end
