# Development use only

require 'populator'
require 'faker'

desc "Fills database with fake data"
task faker: :environment do
  [Course, Lesson, User, Share].each(&:destroy_all)
  10.times.each do |n|
    User.create(
      email: "fake_email_#{n}@gmail.com",
      first_name: Populator.words(1).titleize,
      last_name: Populator.words(1).titleize,
      sex: 'male',
      password: '123456',
      password_confirmation: '123456'
    )
  end
  user = User.first

  interest_tree = {}
  Interest.includes(:sub_interests).map{ |interest| interest_tree[interest.id] = interest.sub_interests.map(&:id) }
  Course.populate(100) do |course|
    course.interest_id = interest_tree.keys.sample
    course.sub_interest_id = interest_tree[course.interest_id].sample
    course.name = Populator.words(3..10).titleize
    course.times_per_week = 1..7
    course.owner_id = user.id
    course.city = 'odessa'
    course.description = Populator.sentences(2..10)
    course.tease_description = Populator.sentences(2..10)

    Lesson.populate(0..7) do |lesson|
      lesson.interest_id = course.interest_id
      lesson.sub_interest_id = course.sub_interest_id
      lesson.name = Populator.words(3..10).titleize
      lesson.city = 'odessa'
      lesson.course_id = [nil, course.id].sample
      lesson.level = %w(beginner low medium high expert)
      lesson.duration = 45..240
      lesson.duration = lesson.duration - lesson.duration % 15
      lesson.description = Populator.sentences(2..10)
      lesson.tease_description = Populator.sentences(2..10)
      lesson.capacity = 20..40
      lesson.place_price = 50..350
      lesson.start_datetime = (Time.now + 1.days)..(Time.now + 10.days)

      Share.create(user_id: user.id, lesson_id: lesson.id, share_type: 'teach')
    end

  end
end

