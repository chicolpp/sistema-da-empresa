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
      _params = manutencao_contato_params

      poco = Poco.find_by(id: _params[:poco_id] )
      pessoa = poco.cliente.pessoa

      url_poco = casein_poco_url(poco)

      body = {
        uuid: pessoa.uuid,
        cpf_cnpj: pessoa.cpf_cnpj,
        name: pessoa.nome,
        poco: poco.apelido_endereco,
        description: "<p>#{_params[:observacao]}</p><p><b>Poço: </b><a href=\"#{url_poco}\" target=\"_blank\">#{url_poco}</a></p>"
      }

      url = URI("#{ENV['CRM_SYNC_HOST']}/sync/maintenances")
      http = Net::HTTP.new(url.host, url.port);
      request = Net::HTTP::Post.new(url)
      request["Auth-Token"] = ENV['CRM_SYNC_TOKEN']
      request["Content-Type"] = "application/json"
      request.body = body.to_json
      http.use_ssl = url.port == 443

      begin
        resp = http.request( request )

        if resp.code.to_i < 300
          flash[:notice] = 'Cadastrado com sucesso no CRM!'

          poco.update(lock_schedule_maintenance: true, schedule_maintenance_at: nil)

          redirect_to casein_dashboard_path
        else
          flash[:warning] = 'Ocorreu um erro ao integrar com o CRM, verefique os dados e tente novamente!'
          redirect_to casein_dashboard_path
        end
      rescue
        flash[:warning] = 'Ocorreu um erro ao integrar com o CRM, verefique os dados e tente novamente!'
        redirect_to casein_dashboard_path
      end

      # if @manutencao_contato.save
      # else
      # end
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