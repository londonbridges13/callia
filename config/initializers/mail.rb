require 'mail'

Mail.defaults do
  delivery_method :smtp, {
    :port      => 587,
    :address   => "smtp.mailgun.org",
    :user_name => "postmaster@support.callia.us",
    :password  => "dcd2d62a798dfa0f863bb70b9edb8f7d",
    
  }
end
