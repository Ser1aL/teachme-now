namespace :db do

  # Development use only
  desc "Fills database with fake data"
  task prefill: :environment do
    [Lesson, User, Share, UserRegistration, Comment].each(&:destroy_all)
    users = []
    10.times.each do |n|
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

    interests = Interest.all

    Lesson.populate(0..23) do |lesson|
      interest = interests.sample
      sub_interest = interest.sub_interests.sample

      lesson.interest_id = interest.id
      lesson.sub_interest_id = sub_interest.id
      lesson.name = Populator.words(3..10).titleize
      lesson.city = 'odessa'
      lesson.level = %w(beginner low medium high expert)
      lesson.address_line = Populator.words(1..2).titleize + ' St.'
      lesson.duration = 45..240
      lesson.duration = lesson.duration - lesson.duration % 15
      lesson.description_top = Populator.sentences(2..10)
      lesson.description_bottom = Populator.sentences(2..10)
      lesson.capacity = 20..40
      lesson.place_price = 50..350
      lesson.places_taken = 0
      lesson.start_datetime = (Time.now + 1.days)..(Time.now + 10.days)
      lesson.enabled = true
      lesson.adjusted_price = 50..350
      lesson.sale_enabled = [true, false]

      Share.create(user_id: user.id, lesson_id: lesson.id, share_type: 'teach')
    end

    Lesson.first(100).each do |lesson|
      rand(4).times do |i|
        image = File.open(File.join(Rails.root, 'app', 'assets', 'images', "img-gallery-#{rand(4)+1}.jpg"), 'r')
        lesson.image_attachments << ImageAttachment.create(image: image)
      end
    end

    Lesson.all.each &:save
    Lesson.update_all enabled: true
  end

  task recreate: [:environment, :drop, :create, :migrate, :seed, :prefill]
end
