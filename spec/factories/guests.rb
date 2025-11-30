FactoryBot.define do
  factory :guest do
    email      { 'wayne_woodbridge@bnb.com' }
    first_name { 'Wayne' }
    last_name  { 'Woodbridge' }
    phone_numbers { [ '639123456789' ] }
  end
end
