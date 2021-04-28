#encoding: utf-8
module Casein
  class AssistenciaPosvendasController < Casein::CaseinController
    load_and_authorize_resource

    def index
      @casein_page_title = 'Listar Pós Vendas de Assistência'
  		if current_user.access_level == 10
        @query = "admin_user_id = #{current_user.id}"
      end
      @assistencia_posvendas = AssistenciaPosvenda.where(@query).order(sort_order(:cliente_id)).paginate :page => params[:page]
    end
  
    def show
      @casein_page_title = 'Visualizar Pós Venda de Assistência'
      @assistencia_posvenda = AssistenciaPosvenda.find params[:id]
    end
  
    def new
      @casein_page_title = 'Adicionar Pós Venda de Assistência'
    	@assistencia_posvenda = AssistenciaPosvenda.new
    end

    def create
      @assistencia_posvenda = AssistenciaPosvenda.new assistencia_posvenda_params
    
      if @assistencia_posvenda.save
        flash[:notice] = 'Pós Venda de Assistência foi cadastrado com sucesso.'
        redirect_to casein_assistencia_posvenda_path(@assistencia_posvenda)
      else
        flash.now[:warning] = 'Ocorreram problemas ao tentar salvar o Pós Venda de Assistência.'
        render :action => :new
      end
    end
  
    def update
      @casein_page_title = 'Atualizar Pós Venda de Assistência'
      
      @assistencia_posvenda = AssistenciaPosvenda.find params[:id]
    
      if @assistencia_posvenda.update_attributes assistencia_posvenda_params
        flash[:notice] = 'Pós Venda de Assistência foi atualizado com sucesso.'
        redirect_to casein_assistencia_posvenda_path(@assistencia_posvenda)
      else
        flash.now[:warning] = 'Ocorreram problemas ao tentar atualizar o Pós Venda de Assistência.'
        render :action => :show
      end
    end
 
    def destroy
      @assistencia_posvenda = AssistenciaPosvenda.find params[:id]

      @assistencia_posvenda.destroy
      flash[:notice] = 'Pós Venda de Assistência foi apagado com sucesso.'
      redirect_to casein_assistencia_posvendas_path
    end
  
    private
      
      def assistencia_posvenda_params
        params.require(:assistencia_posvenda).permit(:cliente_id, :admin_user_id, :pergunta1, :pergunta1_outros, :pergunta2, :pergunta3, :pergunta3_motivo, :pergunta4, :pergunta4_motivo, :pergunta5, :pergunta5_motivo, :pergunta6, :pergunta6_motivo, :pergunta7, :pergunta8, :pergunta9, :pergunta9_motivo, :pergunta10)
      end

  end
end