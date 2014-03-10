class ProWorker

  @queue = :'pro_queue'
  @logger = Logger.new('log/pro_queue.log')

  def self.perform
    User.where('pro_account_due < ?', Time.now).each(&:disable_pro_account)
  end

end