class CleanAccountsScheduler

  def perform
    now = DateTime.now
    User.where(token: nil).where('created_at < ?', now - 5.minutes).destroy_all
    User.where(last_activity: nil).destroy_all
  end

end