class HomeController < ApplicationController

  def index
    redirect_to casein_dashboard_url
  end

  def carregar_cidades
    @cidades = Cidade.where(estado_id: params[:estado_id]).all
    @target = params[:target]

    respond_to do |format|
      format.js
    end
  end

  def get_cidades
    cidades = Cidade.includes(:estado).joins(:estado).where("estados.nome LIKE :q OR cidades.nome LIKE :q OR estados.sigla LIKE :q", q: "%#{params[:q]}%")
    render json: {items: cidades.map{|c| {id: c.id, name: c.get_nome_completo} }, total_count: cidades.count}
  end

  def carregar_pocos
    @pocos = Poco.joins("JOIN usuario_cidades ON usuario_cidades.cidade_id = pocos.cidade_id AND usuario_cidades.admin_user_id = '#{current_user.id}'").where(cliente_id: params[:cliente_id])
    @target = params[:target]

    respond_to do |format|
      format.js
    end
  end

  def carregar_dados_poco
    @poco = Poco.find(params[:poco_id])
    @target = params[:target]

    respond_to do |format|
      format.js
    end
  end
end
