module LessonsHelper

  def select_level(lesson)
    options_for_select(%w(beginner low medium high expert).map{ |option| [t("lesson_form.#{option}"), option] }, lesson.try(:level))
  end

  def select_hours(lesson)
    options_for_select((0..12).map{|i| [pluralize(i, 'hour'), i] }, lesson.try(:duration).try(:/, 60))
  end

  def select_minutes(lesson)
    options_for_select([0, 15, 30, 45].map{ |i| [ pluralize(i, 'minute'), i ] }, lesson.try(:duration).try(:%, 60))
  end
end
