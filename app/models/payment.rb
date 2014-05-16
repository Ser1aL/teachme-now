class Payment < ActiveRecord::Base
  # attr_accessible :amount, :contact_phone, :currency, :vendor, :vendor_token, :referenced, :raw_response

  class << self

    def create_liqpay_enrollment(params)
      if success_status?(params) && signature_valid?(params) && amount_valid?(params)
        lesson_id, user_id, pro_months = params[:order_id].split('_')
        lesson = Lesson.find(lesson_id) rescue nil
        user = User.find(user_id)

        create_lesson_payment(lesson, user, params) if lesson.present? # lesson bought
        create_pro_account_payment(user, params) if pro_months.to_i > 0 # pro bought

        response = { response: 'success', transaction: params[:transaction_id], lesson: lesson, user: user }
        response.merge!({ pro_due: (Time.now + pro_months.to_i.months).to_s(:russian) }) if pro_months.to_i > 0

        response
      else
        { response: 'failure', error: 'hints.payment_page.liqpay.transaction_not_successful' }
      end

    rescue => enrollment_exception
      Rails.logger.error "Enrollment exception: #{enrollment_exception.message}"
      Rails.logger.error "Enrollment exception[backtrace]: #{enrollment_exception.backtrace}"
      { response: 'failure', error: 'hints.payment_page.liqpay.invalid_liqpay_response' }
    end

    # private

    def success_status?(params)
      params[:status] == 'success' || Rails.env.development? && params[:status] == 'sandbox'
    end

    def signature_valid?(params)
      string = [
          Lesson::MERCHANT_SIGNATURE,
          params[:amount],
          params[:currency],
          Lesson::MERCHANT_ID,
          params[:order_id],
          params[:type],
          params[:description],
          params[:status],
          params[:transaction_id],
          params[:sender_phone]
      ].map(&:to_s).join

      Base64.encode64(Digest::SHA1.digest(string)).strip == params[:signature].strip
    end

    def create_lesson_payment(lesson, user, params)
      Share.create(user: user, lesson: lesson, share_type: 'study')
      lesson.increment!(:places_taken)

      save_payment(params)
    end

    def create_pro_account_payment(user, params)
      _, _, pro_months = params[:order_id].split('_')
      user.update_column(:pro_account_due, Time.now + pro_months.to_i.months)
      user.update_column(:pro_account_enabled, true)

      save_payment(params)
    end

    def save_payment(params)
      self.create(
          amount: params[:amount],
          contact_phone: params[:sender_phone],
          currency: params[:currency],
          vendor: 'LiqPay',
          vendor_token: params[:transaction_id],
          referenced: "order_id:#{params[:order_id]}",
          raw_response: params.to_yaml
      )
    end

    def amount_valid?(params)
      lesson_id, _, pro_months = params[:order_id].split('_')
      lesson_amount = Lesson.find(lesson_id).adjusted_price rescue 0
      pro_amount = pro_months.to_i > 0 ? Lesson::PRO_PRICE_RELATIONS[pro_months.to_s].to_i * pro_months.to_i : 0

      lesson_amount + pro_amount == params[:amount].to_i
    end

  end
end
