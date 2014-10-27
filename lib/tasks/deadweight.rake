if Rails.env.development?
  require 'deadweight'

  Deadweight::RakeTask.new do |dw|
    dw.stylesheets = [
      "/assets/classes.css?body=1",
      "/assets/comments.css?body=1",
      "/assets/courses.css?body=1",
      "/assets/edit_profile.css?body=1",
      "/assets/lesson_list.css?body=1",
      "/assets/lessons.css?body=1",
      "/assets/main.css?body=1",
      "/assets/new_course.css?body=1",
      "/assets/new_lesson.css?body=1",
      "/assets/passes.css?body=1",
      "/assets/sessions.css?body=1",
      "/assets/static_pages.css?body=1",
      "/assets/teachers.css?body=1",
      "/assets/user_interests.css?body=1",
      "/assets/users.css?body=1"
    ]
    dw.pages = [
      "/users/1/interests",
      "/users/1/teacher_lessons",
      "/users/1/student_lessons",
      "/users/1/watchlist_lessons",
      "/users/1/pro",
      "/users/1",
      "/lessons",
      "/lessons/new",
      "/lessons/1",
      "/teachers/search",
      "/teachers/asc",
      "/teachers",
      "/static/:page_name",
      "/passes/buy/1",
      "/passes/book/1",
      "/d/users/sign_in",
      "/d/users/password/new",
      "/d/users/cancel",
      "/d/users/sign_up",
      "/"
    ]
  end
end
