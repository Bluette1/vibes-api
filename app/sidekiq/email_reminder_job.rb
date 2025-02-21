class EmailReminderJob < ApplicationJob
  queue_as :default

  def perform
    users = User.where(email_notifications_enabled: true)
    users.each do |user|
      UserMailer.reminder_email(user).deliver_now
    end
  end
end
