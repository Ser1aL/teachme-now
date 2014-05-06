module ProSubscriptionsHelper

  def build_pro_option_data(term, selected)
    data = {
        data: {
          pro_term: term,
          pro_total: Lesson::PRO_PRICE_RELATIONS[term.to_s] * term,
          pro_due: (Time.now + term.month).to_s(:russian)
        }
    }
    data.merge!({ class: 'selected' }) if selected.to_i == term.to_i
    data
  end
end
