class MailerWorker

  @queue = :mailer_queue

  def self.perform(*args)
    self.send(args.first.to_sym)
  end

  def self.new_lessons
    start_time, end_time = Date.yesterday.beginning_of_day, Date.yesterday.end_of_day

    User.all.each do |user|
      next if user.email =~ /@vk\.com/

      interests = user.skills.map(&:sub_interest_id)
      @lessons = Lesson.within_creation_time_range(start_time, end_time).enabled.where(sub_interest_id: interests)

      UserMailer.latest_suitable_lessons(user, @lessons).deliver if @lessons.present?
    end
  end

end