module Casein
  class AdminUserSessionsController < Casein::CaseinController
    
    skip_before_action :authorise, only: [:new, :create]
    before_action :requires_no_session_user, except: [:destroy]
  
    layout 'casein_auth'
  
    def new
      @admin_user_session = Casein::AdminUserSession.new
    end
  
    def create
      @admin_user_session = Casein::AdminUserSession.new casein_admin_user_session_params

      if @admin_user_session.save
        ultimo_login = @admin_user_session.attempted_record.last_login_at
        ultimo_alerta = Alerta.last

        unless ultimo_alerta.blank?
          if ultimo_alerta.updated_at > ultimo_login
            flash[:notice] = "Existe um Alerta atualizado recentemente, por favor verifique!"
          end
        end

        redirect_back_or_default controller: :casein, action: :index
      else
        render action: :new
      end
    end
  
    def destroy
      current_admin_user_session.destroy
      redirect_back_or_default new_casein_admin_user_session_url
    end

  private
  
    def requires_no_session_user
      if current_user
        redirect_to controller: :casein, action: :index
      end
    end
    
    def casein_admin_user_session_params
      params.require(:casein_admin_user_session).permit(:login, :password, :remember_me)
    end

  end
end