#encoding: utf-8
module Casein
  class FotosController < Casein::CaseinController
    load_and_authorize_resource
    before_filter :authorise, :except => [:create]
  
    def index
      @casein_page_title = 'Fotos'

      query = ""
      query = "casein_admin_user_id = #{@session_user.id}" unless @session_user.is_admin?

  		@fotos = Foto.where(query).order(:status, created_at: :desc)
    end
  
    def show
      @casein_page_title = 'View foto'
      @foto = Foto.find params[:id]

      if @foto.casein_admin_user_id != @session_user.id && !@session_user.is_admin?
        flash.now[:warning] = 'Sem permissão para visualizar esta foto!'
        redirect_to casein_fotos_path
      end
    end
  
    # def new
    #   @casein_page_title = 'Add a new foto'
    # 	@foto = Foto.new
    # end

    def create
      params[:foto][:foto].each do |foto|
        @foto = Foto.new foto_params.merge(foto: foto)
        @foto.casein_admin_user_id = @session_user.id unless @session_user.blank?

        if @foto.save
          @error = false
        end
      end
      
      if @error != false
        flash[:notice] = 'Foto adicionada com sucesso'

        if params[:nao_logado] != "sim" 
          redirect_to casein_fotos_path
        else
          Mailer.alerta_cadastro_foto.deliver
          redirect_to root_url
        end
      else
        flash.now[:warning] = 'Ocorreu um erro. Verifique os dados e tente novamente!'
        if params[:nao_logado] != "sim" 
          redirect_to casein_fotos_path
        else
          redirect_to root_url
        end
      end
    end
  
    def edit
      @foto = Foto.find params[:id]
    end
  
    def update
      @casein_page_title = 'Update foto'
      
      @foto = Foto.find params[:id]
    
      if @foto.update_attributes foto_params
        if params[:multiplas] == "on"
          fotos_temp = Foto.where(nome: @foto.nome).all
          fotos_temp.each do |foto_temp|
            foto_temp.update_attributes(poco_id: @foto.poco_id)
          end
        end

        flash[:notice] = 'Foto atualizada com sucesso'
        redirect_to casein_fotos_path
      else
        flash.now[:warning] = 'There were problems when trying to update this foto'
        render :action => :show
      end
    end
 
    def destroy
      @foto = Foto.find params[:id]

      @foto.destroy
      flash[:notice] = 'Foto apagada com sucesso'
      redirect_to casein_fotos_path
    end
  
    private
      
      def foto_params
        params.require(:foto).permit(:casein_admin_user_id, :poco_id, :observacao, :status, :nome, :foto)
      end

  end
end