ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.perform_deliveries = true

ActionMailer::Base.default_url_options = { :host => 'localhost:3000' }

ActionMailer::Base.smtp_settings = {
  :address              => "smtp.sparkpostmail.com",
  :port                 => "587",
  :domain               => "www.twoweb.com.br",
  :user_name            => "SMTP_Injection",
  :password             => "470bec9ead94b827baa8c14a2c260525c2b73e06",
  :authentication       => :plain,
}

ActionMailer::Base.delivery_method = :smtp
