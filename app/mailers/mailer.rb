#encoding: utf-8
class Mailer < ActionMailer::Base
  default :from => "#{ENV['SYSTEM_NAME']} <#{ENV['SMTP_EMAIL_FROM']}>"

  def alerta_email_vendedor(poco, vendedor)
    @poco = poco

    @to_email = Array.new

    if Rails.env.production?
      @to_email << vendedor.email unless vendedor.email.blank?
    else
      @to_email << ENV['DEVELOPER_MAIL']
    end

    mail(:to => @to_email.join(","), :subject => "#{ENV['SYSTEM_NAME_ABBR']} - Alerta de Manutenção")
  end

  def alerta_cadastro_foto
    @to_email = Array.new
    if Rails.env.production?
      @to_email << ENV['NOFITY_MAIL']
    else
      @to_email << ENV['DEVELOPER_MAIL']
    end

    mail(:to => @to_email.join(","), :subject => "#{ENV['SYSTEM_NAME_ABBR']} - Alerta de cadastro de Foto")
  end

end
