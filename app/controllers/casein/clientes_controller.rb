module Casein
  class ClientesController < Casein::CaseinController
    load_and_authorize_resource

    has_scope :nome
    has_scope :tipo
    has_scope :cidade_id
    has_scope :estado_id

    def index
      @casein_page_title = t('clientes.index.titulo')

      respond_to do |format|
        format.html
        format.json { render json: ClienteDatatable.new(view_context) }
      end
    end

    def show
      @casein_page_title = t('clientes.show.titulo')
      @cliente = Cliente.find params[:id]
    end

    def edit
      # @casein_page_title = t('clientes.edit.titulo')
      @cliente = Cliente.find params[:id]
      @pessoa = @cliente.pessoa
      @pessoa.build_pessoa_fisica unless @pessoa.pessoa_fisica
      @pessoa.build_pessoa_juridica unless @pessoa.pessoa_juridica
      @pessoa.build_pessoa_endereco unless @pessoa.pessoa_endereco
      @pessoa.pessoas_contatos.build
    end

    def new
      @casein_page_title = t('clientes.new.titulo')
    	@cliente = Cliente.new
      @pessoa = @cliente.build_pessoa
      @pessoa.build_pessoa_fisica
      @pessoa.build_pessoa_juridica
      @pessoa.build_pessoa_endereco
      @pessoa.pessoas_contatos.build
    end

    def create
      @cliente = Cliente.new cliente_params

      if @cliente.save
        flash[:notice] = t('clientes.create.sucesso', nome: @cliente.pessoa.nome)
        redirect_to casein_clientes_path
      else
        flash.now[:warning] = t('clientes.create.alerta')
        render :action => :new
      end
    end

    def update
      @casein_page_title = t('clientes.update.titulo')
      @cliente = Cliente.find params[:id]

      if @cliente.update_attributes cliente_params
        flash[:notice] = t('clientes.update.sucesso', nome: @cliente.pessoa.nome)
        redirect_to casein_clientes_path
      else
        flash.now[:warning] = t('clientes.update.alerta')
        render :action => :edit
      end
    end

    def destroy
      @cliente = Cliente.find params[:id]

      @cliente.destroy
      flash[:notice] = t('clientes.destroy.sucesso')
      redirect_to casein_clientes_path
    end

    def filtro_relatorio
      if params[:nome] && params[:nome] != '' || params[:tipo] && params[:tipo] != '' || params[:cidade_id] && params[:cidade_id] != '' || params[:estado_id] && params[:estado_id] != ''
        @clientes = apply_scopes(Cliente).all
        
        respond_to do |format|
          format.html
          format.pdf do
            render  template: "casein/clientes/imprimir_cliente",
                handlers: [:erb],
                formats: [:pdf],
                page_size: "A3",
                pdf: "cliente_#{Time.zone.now.to_s}",
                layout: 'layouts/pdf/pdf.html',
                header: {:html => {:template => 'layouts/pdf/header', handlers: [:erb], formats: [:pdf]}, :spacing => 8, :line => false},
                footer: {:html => {:template => 'layouts/pdf/footer', handlers: [:erb], formats: [:pdf]}, :line => false},
                margin: { :bottom => 20, :top => 35}
          end
        end
      end
    end

    private

      def cliente_params
        params.require(:cliente).permit(:pessoa_id, :data_inicio, :data_final, pessoa_attributes: [:id, :nome])
      end

  end
end
