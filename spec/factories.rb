FactoryGirl.define do
  factory :user do
    username "Pekka"
    password "Foobar1"
    password_confirmation "Foobar1"
  end

  factory :rating do
    score 10
    user
  end
  factory :rating3, class: Rating do
    score 17
    user
  end
  factory :rating4, class: Rating do
    score 30
    user
  end

  factory :rating2, class: Rating do
    score 20
  end

  factory :brewery do
    name "anonymous"
    year 1900
    active true
  end

  factory :style do
    name "Lager"
  end

  factory :beer do
    name "anonymous"
    brewery
    style
  end


end
