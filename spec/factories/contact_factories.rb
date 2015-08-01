FactoryGirl.define do
  factory :contact do
    assigned_to         nil
    reports_to          nil
    first_name          { FFaker::Name.first_name }
    last_name           { FFaker::Name.last_name }
    access              "Public"
    title               nil
    department          nil
    source              nil
    email               { FFaker::Internet.email }
    alt_email           { FFaker::Internet.email }
    phone               { FFaker::PhoneNumber.phone_number }
    mobile              { FFaker::PhoneNumber.phone_number }
    fax                 { FFaker::PhoneNumber.phone_number }
    do_not_call         false
    born_on             "1992-10-10"
    background_info     { FFaker::Lorem.paragraph[0,255] }
    deleted_at          nil
    updated_at          { FactoryGirl.generate(:time) }
    created_at          { FactoryGirl.generate(:time) }
    cf_vend_customer_id nil
  end

end
