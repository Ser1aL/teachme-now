class Payment < ActiveRecord::Base
  attr_accessible :amount, :contact_phone, :currency, :vendor, :vendor_token, :referenced, :raw_response

  class << self

    def create_liqpay_enrollment(payload)
      payload = Hash.from_xml(Base64.decode64(payload)).with_indifferent_access[:response]

      lesson_id, user_id = payload[:goods_id].split('_')
      lesson = Lesson.find(lesson_id)
      user = User.find(user_id)
      if payload[:status] != 'success'
        return { response: 'failure', error: 'hints.payment_page.liqpay.transaction_not_successful' }
      else
        self.transaction do
          Share.create(user: user, lesson: lesson, share_type: 'study')
          self.create(
            amount: payload[:amount],
            contact_phone: payload[:sender_phone],
            currency: 'uah',
            vendor: 'liqpay',
            vendor_token: payload[:transaction_id],
            referenced: "lesson:#{lesson_id}",
            raw_response: payload.to_yaml
          )
          lesson.increment!(:places_taken)
        end
        { response: 'success', transaction: payload[:transaction_id], lesson: lesson }
      end
    rescue => enrollment_exception
      Rails.logger.error "Enrollment exception: #{enrollment_exception.message}"
      Rails.logger.error "Enrollment exception[backtrace]: #{enrollment_exception.backtrace}"
      { response: 'failure', error: 'hints.payment_page.liqpay.invalid_liqpay_response' }
    end

  end
end
