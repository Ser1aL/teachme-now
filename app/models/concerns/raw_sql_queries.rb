module RawSqlQueries
  extend ActiveSupport::Concern

  module ClassMethods

    def find_teachers_info
      create_teachers_info_table = '
        CREATE OR REPLACE VIEW teachers_info_table AS
        SELECT users.* , COUNT(users.id) AS total_lessons , SUM(lessons.duration)/60 AS total_hours , SUM(lessons.places_taken) AS total_students
        FROM users
        INNER JOIN shares
        ON shares.user_id = users.id
        INNER JOIN lessons
        ON lessons.id = shares.lesson_id
        WHERE shares.share_type = "teach"
        GROUP BY users.id'

      create_teachers_rating_table = '
        CREATE OR REPLACE VIEW teachers_rating_table AS
        SELECT ratings.taker_id, SUM(ratings.rating) AS teacher_rating
        FROM ratings
        WHERE ratings.taker_id IN
        (
          SELECT users.id
          FROM users
          INNER JOIN shares
          ON shares.user_id = users.id
          WHERE shares.share_type = "teach"
          GROUP BY users.id
        )
        GROUP BY taker_id'

      ActiveRecord::Base.connection.execute(create_teachers_info_table)
      ActiveRecord::Base.connection.execute(create_teachers_rating_table)

      User.find_by_sql(
          %q{
          SELECT *
          FROM teachers_info_table
          LEFT JOIN teachers_rating_table
          ON teachers_info_table.id = teachers_rating_table.taker_id
          UNION
          SELECT *
          FROM teachers_info_table
          RIGHT JOIN teachers_rating_table
          ON teachers_info_table.id = teachers_rating_table.taker_id
        }
      )
    end
  end
end