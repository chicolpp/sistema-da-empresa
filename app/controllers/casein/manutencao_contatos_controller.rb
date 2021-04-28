module Casein
  class ManutencaoContatosController < Casein::CaseinController
    load_and_authorize_resource
  
    def index
      @casein_page_title = 'Manutencao contatos'
  		@manutencao_contatos = ManutencaoContato.where(poco_id: params[:poco_id]).order(nova_data: :desc)
      @poco = Poco.where(id: params[:poco_id]).first
    end
  
    # def show
    #   @casein_page_title = 'View manutencao contato'
    #   @manutencao_contato = ManutencaoContato.find params[:id]
    # end
  
    # def new
    #   @casein_page_title = 'Add a new manutencao contato'
    # 	@manutencao_contato = ManutencaoContato.new
    # end

    def create
      @manutencao_contato = ManutencaoContato.new manutencao_contato_params
    
      if @manutencao_contato.save
        flash[:notice] = 'Cadastrado com sucesso!'
        redirect_to casein_dashboard_path
      else
        flash[:warning] = 'Ocorreu um erro, verefique os dados e tente novamente!'
        redirect_to casein_dashboard_path
      end
    end
  
    def update
      @casein_page_title = 'Update manutencao contato'
      
      @manutencao_contato = ManutencaoContato.find params[:id]
    
      if @manutencao_contato.update_attributes manutencao_contato_params
        flash[:notice] = 'Manutencao contato has been updated'
        redirect_to casein_manutencao_contatos_path
      else
        flash.now[:warning] = 'There were problems when trying to update this manutencao contato'
        render :action => :show
      end
    end
 
    def destroy
      @manutencao_contato = ManutencaoContato.find params[:id]

      @manutencao_contato.destroy
      flash[:notice] = 'Manutencao contato has been deleted'
      redirect_to casein_manutencao_contatos_path
    end
  
    private
      
      def manutencao_contato_params
        params.require(:manutencao_contato).permit(:poco_id, :observacao, :nova_data)
      end

  end
end