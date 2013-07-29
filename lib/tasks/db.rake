# Development use only

desc "Fills database with fake data"

namespace :db do
  task prefill: :environment do
    [Course, Lesson, User, Share, UserRegistration, Comment].each(&:destroy_all)
    users = []
    40.times.each do |n|
      users << User.create(
        email: "fake_email_#{n}@gmail.com",
        first_name: Populator.words(1).titleize,
        last_name: Populator.words(1).titleize,
        sex: 'male',
        password: '123456',
        password_confirmation: '123456'
      )
    end
    user = users.sample

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

      Lesson.populate(0..7) do |lesson|
        lesson.interest_id = course.interest_id
        lesson.sub_interest_id = course.sub_interest_id
        lesson.name = Populator.words(3..10).titleize
        lesson.city = 'odessa'
        lesson.course_id = [nil, course.id].sample
        lesson.level = %w(beginner low medium high expert)
        lesson.address_line = Populator.words(1..2).titleize + ' St.'
        lesson.duration = 45..240
        lesson.duration = lesson.duration - lesson.duration % 15
        lesson.description_top = Populator.sentences(2..10)
        lesson.description_bottom = Populator.sentences(2..10)
        lesson.capacity = 20..40
        lesson.place_price = 50..350
        lesson.start_datetime = (Time.now + 1.days)..(Time.now + 10.days)

        Share.create(user_id: user.id, lesson_id: lesson.id, share_type: 'teach')
      end

    end


    Lesson.first(100).each do |lesson|
      rand(4).times do |i|
        image = File.open(File.join(Rails.root, 'app', 'assets', 'images', "img-gallery-#{rand(4)+1}.jpg"), 'r')
        lesson.image_attachments << ImageAttachment.create(image: image)
      end
    end
  end
end
