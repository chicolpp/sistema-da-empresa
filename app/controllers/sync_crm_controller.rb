class SyncCrmController < ActionController::Base
	skip_before_filter :verify_authenticity_token
  before_action :auth_token!

  rescue_from Exeptions::AccessDenied do |exception|
    render json: { message: exception.message } , status: 401
  end

  def products
    product = Produto.find_by(uuid: params[:uuid]) || Produto.new(uuid: params[:uuid])
    product.assign_attributes(descricao: params[:descricao], exibir_app: params[:exibir_app])
    unidade = nil
    if(params[:unidade_medida].present?)
      product.unidade_medida = UnidadeMedida.find_or_create_by(descricao: params[:unidade_medida])
    end
    product.auto_sync = false
    product.save!
    render json: {data: product.as_json}
  end

  def services
    service = Servico.find_by(uuid: params[:uuid]) || Servico.new(uuid: params[:uuid])
    service.assign_attributes(descricao: params[:descricao])
    service.auto_sync = false
    service.save
    render json: {data: service.as_json}
  end

  def people
    person = Pessoa.find_by(uuid: params[:uuid])
    person ||= Pessoa.joins(:pessoa_fisica).where(pessoas_fisicas: {cpf: params[:cpf_cnpj]} ).first
    person ||= Pessoa.joins(:pessoa_juridica).where(pessoas_juridicas: {cnpj: params[:cpf_cnpj]} ).first
    person ||= Pessoa.new(uuid: params[:uuid])
    person.assign_attributes(person_attributes)

    if person.tipo? # Juridica
      handle_pessoa_juridica!(person)
    else
      handle_pessoa_fisica!(person)
    end

    handle_address!(person)

    person.auto_sync = false

    person.save
    person.pessoa_juridica.save if person.pessoa_juridica
    person.pessoa_fisica.save   if person.pessoa_fisica
    person.pessoa_endereco.save if person.pessoa_endereco

    resp = person.as_json
    if person.tipo? # Juridica
      resp[:juridica] = person.pessoa_juridica.as_json if person.pessoa_juridica
    else
      resp[:fisica] = person.pessoa_fisica.as_json if person.pessoa_fisica
    end
    resp[:endereco] = person.pessoa_endereco.as_json if person.pessoa_endereco


    render json: {data: resp }
  end

protected

  def auth_token!
    if request.headers['Auth-Token'] != ENV['SYNC_TOKEN']
      access_denied!
    end
  end

	def access_denied!
		raise Exeptions::AccessDenied.new("Acesso Negado")
	end

  def person_attributes
    {
      tipo:               params[:is_juridica],
      nome:               params[:name],
      email_contato:      params[:email],
      email_xml:          params[:email_nfe],
      telefone_principal: params[:phone],
    }
  end

  def handle_pessoa_juridica!(person)
    person.build_pessoa_juridica unless person.pessoa_juridica
    person.pessoa_juridica.assign_attributes({
      cnpj:          params[:cpf_cnpj],
      ie:            params[:state_registration],
      im:            params[:municipal_registration],
      data_fundacao: params[:birth_date],
      nome_fantasia: params[:name]
    })
    person.nome = params[:corporate_name]
  end

  def handle_pessoa_fisica!(person)
    person.build_pessoa_fisica unless person.pessoa_fisica
    person.pessoa_fisica.assign_attributes({
      cpf:                 params[:cpf_cnpj],
      rg:                  params[:rg],
      data_nascimento:     params[:birth_date],
      telefone_auxiliar_1: params[:cell_phone]
    })
  end

  def handle_address!(person)
    return unless params[:address].present?
    person.build_pessoa_endereco unless person.pessoa_endereco

    person.pessoa_endereco.assign_attributes({
      endereco:      params[:address][:rua],
      numero:        params[:address][:numero],
      bairro:        params[:address][:bairro],
      complemento:   params[:address][:complemento],
      cep:           params[:address][:cep],
      tipo_endereco: params[:address][:description],
      cidade:        Cidade.where(estado_id: Estado.select(:id).where(sigla: params[:address][:uf]) ).find_by(nome: params[:address][:city_name])
    })
  end
end