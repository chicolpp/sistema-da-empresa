class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	helper_method :current_admin_user_session, :current_user
	skip_before_filter :verify_authenticity_token  

	# rescue_from CanCan::AccessDenied do |exception|
	# 	flash[:warning] = t('unauthorized.default')
	#    redirect_to main_app.casein_dashboard_path
	#  end

	rescue_from Exeptions::AccessDenied do |exception|
		flash[:warning] = exception.message
		respond_to do |f|
			f.html{redirect_to(casein_pessoas_url, warning: exception.message)}
			f.js{js_redirect_to(casein_pessoas_url)}
		end
	end

	def access_denied!
		raise Exeptions::AccessDenied.new("Acesso Negado")
	end

	rescue_from CanCan::AccessDenied do |exception|
		flash[:warning] = "Accesso Negado!"
		redirect_to casein_dashboard_url
	end

	private

		def current_admin_user_session
			return @current_admin_user_session if defined?(@current_admin_user_session)
			@current_admin_user_session = Casein::AdminUserSession.find
		end

		def current_user
			return @session_user if defined?(@session_user)
			@session_user = current_admin_user_session && current_admin_user_session.admin_user
		end
end
