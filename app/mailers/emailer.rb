class Emailer < ActionMailer::Base
  default from: "ebairagi1@student.gsu.edu"
  
  def contact_mail(name, subject, message, recipient, from_name, from)
  	  @name = name
  	  @subject = subject
  	  @message = message
  	  @recipient = recipient
  	  @from = "#{from_name}<#{from}>"
  	  mail(:subject => @subject, :message => @message, :to => @recipient, :from => @from)
  end
end
