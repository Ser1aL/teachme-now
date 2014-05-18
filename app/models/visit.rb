class Visit < ActiveRecord::Base
  belongs_to :campaign

  class << self

    def by_page(page, per_page = nil)
      per_page ||= APP_CONFIG['lessons_per_page']
      page(page).per(per_page)
    end

  end
end
