class UpdateGradesScheduler

  def perform
    User.find_each(include: :updates) do |user|
      if user.user_ok? and user.main_session.present? and user.last_activity > Time.now - 2.month
        Delayed::Job.enqueue FetchDetailedGradesWorker.new(user.id, user.main_session.id),
                             priority: ApplicationWorker::PR_FETCH_DETAILED_GRADES,
                             queue: ApplicationWorker::QUEUE_DETAILED_GRADES
      end
    end
  end

end