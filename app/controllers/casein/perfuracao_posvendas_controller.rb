#encoding: utf-8
module Casein
  class PerfuracaoPosvendasController < Casein::CaseinController
    load_and_authorize_resource
    
    ## optional filters for defining usage according to Casein::AdminUser access_levels
    # before_filter :needs_admin, :except => [:action1, :action2]
    # before_filter :needs_admin_or_current_user, :only => [:action1, :action2]
  
    def index
      @casein_page_title = 'Listar Pós Vendas de Perfuração'

      if current_user.access_level == 10
        @query = "admin_user_id = #{current_user.id}"
      end
  		
      @perfuracao_posvendas = PerfuracaoPosvenda.where(@query).order(sort_order(:cliente_id)).paginate :page => params[:page]
    end
  
    def show
      @casein_page_title = 'Visualizar Pós Venda de Perfuração'
      @perfuracao_posvenda = PerfuracaoPosvenda.find params[:id]
    end
  
    def new
      @casein_page_title = 'Adicionar Pós Venda de Perfuração'
    	@perfuracao_posvenda = PerfuracaoPosvenda.new
    end

    def create
      @perfuracao_posvenda = PerfuracaoPosvenda.new perfuracao_posvenda_params
    
      if @perfuracao_posvenda.save
        flash[:notice] = 'Pós Venda de Perfuração foi cadastrado com sucesso.'
        redirect_to casein_perfuracao_posvenda_path(@perfuracao_posvenda)
      else
        flash.now[:warning] = 'Ocorreram problemas ao tentar salvar o Pós Venda de Perfuração.'
        render :action => :new
      end
    end
  
    def update
      @casein_page_title = 'Atualizar Pós Venda de Perfuração'
      
      @perfuracao_posvenda = PerfuracaoPosvenda.find params[:id]
    
      if @perfuracao_posvenda.update_attributes perfuracao_posvenda_params
        flash[:notice] = 'Pós Venda de Perfuração foi atualizado com sucesso.'
        redirect_to casein_perfuracao_posvenda_path(@perfuracao_posvenda)
      else
        flash.now[:warning] = 'Ocorreram problemas ao tentar atualizar o Pós Venda de Perfuração.'
        render :action => :show
      end
    end
 
    def destroy
      @perfuracao_posvenda = PerfuracaoPosvenda.find params[:id]

      @perfuracao_posvenda.destroy
      flash[:notice] = 'Pós Venda de Perfuração foi apagado com sucesso.'
      redirect_to casein_perfuracao_posvendas_path
    end
  
    private
      
      def perfuracao_posvenda_params
        params.require(:perfuracao_posvenda).permit(:cliente_id, :admin_user_id, :pergunta1, :pergunta1_outros, :pergunta2, :pergunta3, :pergunta3_email, :pergunta4, :pergunta4_motivo, :pergunta5, :pergunta5_motivo, :pergunta6, :pergunta7, :pergunta8, :pergunta8_motivo, :pergunta8_cliente, :pergunta9)
      end

  end
end