#encoding: utf-8
require 'securerandom'

module Casein
  class AdminUsersController < Casein::CaseinController

    before_filter :needs_admin, :only => [:edit, :show, :destroy, :update, :update_password]
    before_filter :needs_admin_or_current_user, :only => [:edit, :show, :destroy, :update, :update_password]
    has_scope :access_level

    def index
      @casein_page_title = "Usuários"
      @users = Casein::AdminUser.order(sort_order(:login))
    end

    def new
      @casein_page_title = "Add a new user"
    	@casein_admin_user = Casein::AdminUser.new
    	@casein_admin_user.time_zone = Rails.configuration.time_zone
      @casein_admin_user.usuario_cidades.build
    end

    def create
      params[:casein_admin_user][:password_confirmation] = params[:casein_admin_user][:password]
      @casein_admin_user = Casein::AdminUser.new casein_admin_user_params

      if @casein_admin_user.save
        flash[:notice] = "Um email foi enviado para " + @casein_admin_user.email + " com os detalhes do cadastro."
        redirect_to casein_admin_users_path
      else
        flash.now[:warning] = "Ocorreram problemas ao tentar salvar o novo usuario."
        render :action => :new
      end
    end

    def show
      @casein_admin_user = Casein::AdminUser.find params[:id]
      @casein_page_title = "Visualizar"
    end

    def edit
      @casein_admin_user = Casein::AdminUser.find params[:id]
      @casein_admin_user.usuario_cidades.build if @casein_admin_user.usuario_cidades.blank?
    end

    def update
      @casein_admin_user = Casein::AdminUser.find params[:id]
      @casein_page_title = @casein_admin_user.email + " > Update user"
      params[:casein_admin_user][:password_confirmation] = params[:casein_admin_user][:password]

      if @casein_admin_user.update_attributes! casein_admin_user_params
        flash[:notice] = @casein_admin_user.email + " has been updated"
      else
        flash.now[:warning] = "Ocorreram problemas ao tentar atualizar este usuario."
        render :action => :show
        return
      end

      if @session_user.is_admin?
        redirect_to casein_admin_users_path
      else
        redirect_to :controller => :casein, :action => :index
      end
    end

    def update_password
      @casein_admin_user = Casein::AdminUser.find params[:id]
      @casein_page_title = @casein_admin_user.email + " > Update password"

      if @casein_admin_user.valid_password? params[:form_current_password]
        if params[:casein_admin_user][:password].blank? && params[:casein_admin_user][:password_confirmation].blank?
          flash[:warning] = "New password cannot be blank"
        elsif @casein_admin_user.update_attributes casein_admin_user_params
          flash[:notice] = "Your password has been changed"
        else
          flash[:warning] = "There were problems when trying to change your password"
        end
      else
        flash[:warning] = "The current password is incorrect"
      end

      redirect_to :action => :show
    end

    def reset_password
      @casein_admin_user = Casein::AdminUser.find params[:id]
      @casein_page_title = @casein_admin_user.email + " > Reset password"

      if params[:generate_random_password].blank? && params[:casein_admin_user][:password].blank? && params[:casein_admin_user][:password_confirmation].blank?
        flash[:warning] = "New password cannot be blank"
      else
        generate_random_password if params[:generate_random_password]
        @casein_admin_user.notify_of_new_password = true unless (@casein_admin_user.id == @session_user.id && params[:generate_random_password].blank?)

        if @casein_admin_user.update_attributes casein_admin_user_params
          unless @casein_admin_user.notify_of_new_password
            flash[:notice] = "Your password has been reset"
          else
            flash[:notice] = "A senha foi redefinida e " + @casein_admin_user.email + " recebeu um e-mail confirmando."
          end
        else
          flash[:warning] = "There were problems when trying to reset this user's password"
        end
      end

      redirect_to :action => :show
    end

    def destroy
      user = Casein::AdminUser.find params[:id]
      if user.is_admin? == false || Casein::AdminUser.has_more_than_one_admin
        user.destroy
        flash[:notice] = user.email + " has been deleted"
      end
      redirect_to casein_admin_users_path
    end

    def filtro_ajax
      @admin_users = apply_scopes(Casein::AdminUser).order(sort_order(:login))
    end

    private

      def generate_random_password
        random_password = random_string = SecureRandom.hex
        params[:casein_admin_user] = Hash.new if params[:casein_admin_user].blank?
        params[:casein_admin_user].merge! ({:password => random_password, :password_confirmation => random_password})
      end

      def casein_admin_user_params
        params.require(:casein_admin_user).permit(:login, :email, :pessoa_id, :cidade_id, :access_level, :password, :password_confirmation, :pos_venda, usuario_cidades_attributes: [:id, :cidade_id, :_destroy])
      end

  end
end
