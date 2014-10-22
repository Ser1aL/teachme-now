module LessonsHelper

  def skill_level_options(default_level = nil)
    options_for_select(%w(beginner low medium high expert).map{ |option| [t("lesson_form.levels.#{option}"), option] }, default_level)
  end

  def hours_options(default_duration = nil)
    options_for_select((0..12).map{|i| [t("lesson_form.hours", count: i), i]}, default_duration.try(:/, 60))
  end

  def minutes_options(default_duration = nil)
    options_for_select([0, 15, 30, 45].map{ |i| [t("lesson_form.minutes", count: i), i] }, default_duration.try(:%, 60))
  end

  def days_options(default_duration = nil)
    days = (1..30).to_a + [60, 120, 180]
    options_for_select(days.map { |i| [t("lesson_form.days", count: i), i] }, default_duration.try(:%, 60))
  end

  def user_skill_list(user)
    user.skills.map do |skill|
      link_to skill.sub_interest.translation, sub_interest_lessons_path(skill.sub_interest.interest, skill.sub_interest)
    end.join(', ').html_safe
  end

  def format_duration(lesson)
    if lesson.duration.to_i == 0 # permanent lesson
      t('lesson_form.permanent_lesson')
    elsif lesson.duration.to_i / 60 > 12 # likely long running course
      "#{t('lesson_form.akademic_hours_duration')} #{lesson.duration / 60}#{t('lesson.hours_short')}"
    else # usual lesson
      "#{t('lesson_form.duration')} #{lesson.duration / 60}:#{"%02d" % (lesson.duration % 60)}#{t('lesson.hours_short')}"
    end
  end

  def interest_options(interests, selected = nil)
    options = interests.map do |interest|
      [interest.translation, interest.id]
    end
    if selected
      options_for_select(options, selected)
    else
      options_for_select(options)
    end
  end

  def sub_interest_options(interest, selected = nil)
    options = interest.sub_interests.map do |sub_interest|
      [sub_interest.translation, sub_interest.id]
    end
    if selected
      options_for_select(options, selected)
    else
      options_for_select(options)
    end
  end

  def interests_as_json(interests)
    interests.inject({}) do |memo, interest|
      key = interest.translation
      memo[key] = interest.sub_interests.map do |sub_interest|
        [sub_interest.translation, sub_interest.id]
      end

      memo[key].sort_by!{ |sub_interest| sub_interest[0].to_i.size }.reverse!
      memo
    end.to_json
  end

  def calculate_price(lesson, native_lesson_price = false)
    if lesson.course_id.present? && !lesson.course.allow_split_buy? && !native_lesson_price
      lesson.course.calculate_lessons_price
    else
      # single lesson or course allows lesson bought separately
      lesson.adjusted_price
    end
  end

  def dynamic_lesson_path(lesson, force_lesson_path = false)
    if lesson.course.present? && !lesson.course.allow_split_buy? && !force_lesson_path
      course_path(lesson.course)
    else
      lesson_path(lesson)
    end
  end

end
