require 'mail'

Mail.defaults do
  if ENV[:mailgunpw]
    delivery_method :smtp, {
      :port      => 587,
      :address   => "smtp.mailgun.org",
      :user_name => ENV['mailgunuser'],
      :password  => ENV['mailgunpw'],
    }
  end
end
