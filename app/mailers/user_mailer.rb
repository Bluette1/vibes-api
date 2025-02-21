class UserMailer < ApplicationMailer
  # rubocop:disable Layout/LineLength
  def reminder_email(user)
    @user = user
    mail(to: @user.email, subject: 'Time to Meditate!') do |format|
      format.text do
        render plain: "Hi #{@user.email},\n\nIt's time for your daily meditation! Remember to take a moment for yourself.\n\nBest,\nThe Vibes Team"
      end
      format.html do
        render html: "<strong>Hi #{@user.email},</strong><br><br>It's time for your daily meditation! Remember to take a moment for yourself.<br><br>Best,<br>The Vibes Team".html_safe
      end
    end
  end
  # rubocop:enable Layout/LineLength
end
