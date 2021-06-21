module Casein
  class PocosController < Casein::CaseinController
    load_and_authorize_resource

    has_scope :cliente_id
    has_scope :perfuracao_leao
    has_scope :poco_produtivo
    has_scope :tipo_manutencao
    has_scope :cidade_id
    has_scope :estado_id
    has_scope :linha_endereco
    has_scope :apelido_endereco
    has_scope :profundidade_de
    has_scope :profundidade_ate
    has_scope :revestimento_id
    has_scope :funcionario_id
    has_scope :numero_processo
    has_scope :maquina_id
    has_scope :data, :using => [:data_inicial, :data_final], :type => :hash
    has_scope :data_manutencao, :using => [:data_inicial, :data_final], :type => :hash
    
    def index
      @casein_page_title = t('pocos.index.titulo')

      respond_to do |format|
        format.html
        format.json { render json: PocoDatatable.new(view_context) }
      end
    end

    def show

      @casein_page_title = t('pocos.show.titulo')
      @poco = Poco.find(params[:id])
      if @poco.blank?
        flash[:warning] = t("unauthorized.default")
        redirect_to new_casein_poco_path
      else
        # @poco.build_perfuracao unless @poco.perfuracao
        # @poco.build_coordenada unless @poco.coordenada
        # @poco.revestimento_pocos.build
        # @poco.entradas_agua.build
        # @vazao_total = EntradaAgua.where("poco_id = #{@poco.id}").sum('vazao_aproximada')
      end
    end

    def new
      @casein_page_title = t('pocos.new.titulo')
    	@poco = Poco.new
      @poco.build_perfuracao
      @poco.perfuracao.perfuracao_funcionarios.build
      @poco.build_coordenada
      @poco.revestimento_pocos.build
      @poco.entradas_agua.build
      @poco.arquivos.build
    end

    def create
      @poco = Poco.new poco_params.merge(possoidados: params["dados"] == "false")

      if @poco.save
        flash[:notice] = t('pocos.create.sucesso', nome: @poco.cliente.pessoa.nome)

        if params["avancar"]
          redirect_to new_casein_vazao_agua_path(poco: @poco.id)
        else
          redirect_to casein_poco_path(@poco)
        end
      else
        @poco.build_perfuracao unless @poco.perfuracao
        @poco.build_coordenada unless @poco.coordenada
        flash.now[:warning] = t('pocos.create.alerta')
        render :action => :new
      end
    end

    def edit
      @poco = Poco.find(params[:id])
      @poco.build_perfuracao unless @poco.perfuracao
      @poco.perfuracao.perfuracao_funcionarios.build if @poco.perfuracao.perfuracao_funcionarios.blank?
      @poco.build_coordenada unless @poco.coordenada
      @poco.revestimento_pocos.build if @poco.revestimento_pocos.blank?
      @poco.entradas_agua.build if @poco.entradas_agua.blank?
    end

    def update
      @casein_page_title = t('pocos.update.titulo')

      @poco = Poco.find(params[:id])
      if @poco.blank?
        flash[:warning] = t("unauthorized.default")
        redirect_to new_casein_poco_path
      else
        if @poco.update_attributes poco_params.merge(possoidados: params["dados"] == "false")
          flash[:notice] = t('pocos.update.sucesso', nome: @poco.cliente.pessoa.nome)

          if params[:dados].to_s == "true" && !@poco.perfuracao_leao
            @poco.perfuracao.try(:destroy)
          else
            @poco.profundidade = nil
            @poco.save
          end
          
          if params["avancar"]
            @teste_vazao = VazaoAgua.where(poco_id: @poco.id).first

            if @teste_vazao.try(:id)
              redirect_to edit_casein_vazao_agua_path(@teste_vazao)
            else
              redirect_to new_casein_vazao_agua_path(poco: @poco.id)
            end
          else
            redirect_to casein_poco_path(@poco)
          end
        else
          @poco.build_perfuracao unless @poco.perfuracao
          @poco.build_coordenada unless @poco.coordenada
          flash.now[:warning] = t('pocos.update.alerta')
          render :action => :edit
        end
      end
    end

    def destroy

      @poco = Poco.find(params[:id])
      if @poco.blank?
        flash[:warning] = t("unauthorized.default")
        redirect_to new_casein_poco_path
      else
        @poco.destroy
        flash[:notice] = t('pocos.destroy.sucesso')
        redirect_to casein_pocos_path
      end
    end

    def filtro_relatorio
      params[:data] ||= {}
      params[:data_manutencao] ||= {}
      
      if current_user.access_level == 0
        if params[:coringa].present?
          params[:data][:data_final] = nil
          params[:data][:data_inicial] = nil
          params[:data_manutencao][:data_final] = nil
          params[:data_manutencao][:data_inicial] = nil
          params[:cidade_id] = nil
          params[:profundidade_ate] = nil
          params[:profundidade_de] = nil
          params[:perfuracao_leao] = nil
          params[:poco_produtivo] = nil
          params[:tipo_manutencao] = nil
          params[:cliente_id] = nil
          @pocos = Poco.select("pocos.id, pocos.linha_endereco, pocos.apelido_endereco, pocos.cidade_id, pocos.numero_processo, pocos.perfuracao_leao, pocos.poco_produtivo, pocos.cliente_id").joins(cliente: [:pessoa]).joins(:cidade).where("pessoas.nome LIKE '%#{params[:coringa]}%' OR pocos.linha_endereco LIKE '%#{params[:coringa]}%' OR pocos.apelido_endereco LIKE '%#{params[:coringa]}%' OR cidades.nome LIKE '%#{params[:coringa]}%' OR pocos.numero_processo LIKE '%#{params[:coringa]}%'").all.paginate :page => params[:page]
        else
          @pocos = apply_scopes(Poco).select("pocos.id, pocos.linha_endereco, pocos.apelido_endereco, pocos.cidade_id, pocos.numero_processo, pocos.perfuracao_leao, pocos.poco_produtivo, pocos.cliente_id").all.paginate :page => params[:page]
        end
      else  
        @pocos = apply_scopes(Poco).select("pocos.id, pocos.linha_endereco, pocos.apelido_endereco, pocos.cidade_id, pocos.numero_processo, pocos.perfuracao_leao, pocos.poco_produtivo, pocos.cliente_id").where(cidade_id: current_user.usuario_cidades.map { |x| x.cidade_id }).group("pocos.id").paginate :page => params[:page]
      end
       
      respond_to do |format|
        format.html
        format.pdf do
          @poco = Poco.find(params[:id])
          render template: "casein/pocos/imprimir_poco",
              handlers: [:erb],
              formats: [:pdf],
              page_size: "A3",
              pdf: "poco_#{Time.zone.now.to_s}",
              layout: 'layouts/pdf/pdf.html',
              header: {:html => {:template => 'layouts/pdf/header', handlers: [:erb], formats: [:pdf]}, :spacing => 8, :line => false},
              footer: {:html => {:template => 'layouts/pdf/footer', handlers: [:erb], formats: [:pdf]}, :line => false},
              margin: { bottom: 5, top: 5, left: 5, right: 5}
        end
      end
    end

    def filtro_ajax
      @pocos = apply_scopes(Poco).all
    end

    def relatorio_detalhes
      if params[:notification].present?
        notification = Notification.find params[:notification]
        notification.update_attributes(status: true)
      end

      @poco = Poco.find(params[:id])
      @manutencao_contatos = ManutencaoContato.where(poco_id: @poco.id)
      @fotos = Foto.where(poco_id: @poco.id)
    end

    def relatorio_processos
      @pocos = apply_scopes(Poco).all.paginate :page => params[:page]
    end

    def relatorio_assistencias
      @pocos = apply_scopes(Poco).joins(:manutencaos).where(manutencaos: {servico_id: 3}).paginate :page => params[:page]
    end
    
    private

      def poco_params
        params.require(:poco).permit(
          :poco_produtivo, :profundidade, :cliente_id, :linha_endereco, :apelido_endereco, :perfuracao_leao,
          :cidade_id, :observacao, :numero_processo, :schedule_maintenance_at,
          perfuracao_attributes: [
            :id, :poco_id, :data_perfuracao_inicio, :data_perfuracao_fim, :profundidade, :maquina_id, :bitola_id,
            :_destroy,
            perfuracao_funcionarios_attributes: [
              :id, :funcionario_id, :perfuracao_id, :_destroy
            ]
          ],
          coordenada_attributes: [
            :id, :longitude, :latitude, :zona, :poco_id, :_destroy
          ],
          entradas_agua_attributes: [
            :id, :metragem, :vazao_aproximada, :poco_id, :aprofundamento_id, :_destroy
          ],
          revestimento_pocos_attributes: [
            :id, :quantidade, :tipo_revestimento_id, :poco_id, :polegadas, :_destroy
          ],
          arquivos_attributes: [:id, :owner_id, :owner_type, :upload, :_destroy]
        )
      end

  end
end