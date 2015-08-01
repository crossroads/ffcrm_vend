FactoryGirl.define do
  factory :user do
    username            { FactoryGirl.generate(:username) }
    email               { FFaker::Internet.email }
    first_name          { FFaker::Name.first_name }
    last_name           { FFaker::Name.last_name }
    title               nil
    company             { FFaker::Company.name }
    alt_email           { FFaker::Internet.email }
    phone               { FFaker::PhoneNumber.phone_number }
    mobile              { FFaker::PhoneNumber.phone_number }
    aim                 nil
    yahoo               nil
    google              nil
    skype               nil
    admin               false
    password_hash       "56d91c9f1a9c549304768982fd4e2d8bc2700b403b4524c0f14136dbbe2ce4cd923156ad69f9acce8305dba4e63faa884e61fb7a256cf8f5fc7c2ce176e68e8f"
    password_salt       "ce6e0200c96f4dd326b91f3967115a31421a0e7dcddc9ffb63a77f598a9fcb5326fe532dbd9836a2446e46840d398fa32c81f8f4da1a0fcfe931989e9639a013"
    persistence_token   "d7cdeffd3625f7cb265b21126b85da7c930d47c4a708365c20eb857560055a6b57c9775becb8a957dfdb46df8aee17eb120a011b380e9cc0882f9dfaa2b7ba26"
    perishable_token    "TarXlrOPfaokNOzls2U8"
    single_access_token nil
    current_login_at    { FactoryGirl.generate(:time) }
    last_login_at       { FactoryGirl.generate(:time) }
    last_login_ip       "127.0.0.1"
    current_login_ip    "127.0.0.1"
    login_count         { rand(100) + 1 }
    deleted_at          nil
    updated_at          { FactoryGirl.generate(:time) }
    created_at          { FactoryGirl.generate(:time) }
    suspended_at        nil
    password              "password"
    password_confirmation "password"
  end

  sequence :username do |n|
    FFaker::Internet.user_name + n.to_s  # make sure it's unique by appending sequence number
  end

  sequence :time do |n|
    Time.now - n.hours
  end


end
