class UserMailer < ActionMailer::Base
  default from: "ankitjain50000@gmail.com"
  
  def password_reset(user)
    @user = user
    mail( :to => @user.email,
    :subject => 'Password Reset Mail' )
  end

end
