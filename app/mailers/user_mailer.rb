class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def delete_account_email(user)
    @user = user
    mail(to: @user.email, subject: 'Sorry, your account has been deleted.')
  end
  
end
