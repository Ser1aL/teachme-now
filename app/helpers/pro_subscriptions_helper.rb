module ProSubscriptionsHelper

  def build_pro_option_data(term, selected)
    data = {
        data: {
          pro_type: "#{term}month",
          pro_total: Lesson::PRO_PRICE_RELATIONS[term.to_s] * term,
          pro_due: (Time.now + term.month).to_s(:russian)
        }
    }
    data.merge!({ class: 'selected' }) if selected == "#{term}month"
    data
  end
end
