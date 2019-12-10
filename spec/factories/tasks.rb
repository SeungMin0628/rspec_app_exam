FactoryBot.define do
  factory :task do
    title { Faker::Job.unique.title }
    status { rand(2) }
    from = Date.parse("2019/08/01")
    to   = Date.parse("2019/12/31")
    deadline { Random.rand(from..to) }

    trait :complete do
      status { :done }
      completion_date { Time.current.yesterday }
    end
  end
end
