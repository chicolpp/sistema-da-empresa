class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :produtos, :ordens, :funcionarios, :cidades, :estados, :servicos, :energias


  def estados
    Estado.all
  end

  def cidades
    Cidade.all
  end

  def produtos
    Produto.all
  end

  def servicos
    Servico.select(:id, :descricao, :exibe_app).order(:descricao)
  end

  def energias
    Energia.select(:id, :descricao).order(:descricao)
  end

  def ordens
    ordens = []
    object.ordem_servicos.sync_includes.where('status = 1 or status = 4').each do |ordem|
      manutencao = Manutencao.find_by(ordem_servico_id: ordem.id)

      if manutencao.present?
        fotos = []
        manutencao.arquivos.each do |arquivo|
          fotos.push({nome: arquivo.nome, upload: arquivo.upload.url()})
        end
      end

      ordens.push({
        id: ordem.id,
        sintoma: ordem.sintoma,
        created_at: ordem.created_at,
        data_proxima_etapa: ordem.data_proxima_etapa,
        status_code: ordem.status_code,
        cliente: {
          nome: ordem.poco.cliente.pessoa.nome,
          cidade: ordem.poco.cidade.id,
          estado: ordem.poco.cidade.estado.id,
          status: ordem.status,
          cpfcnpj: ordem.poco.cliente.pessoa.tipo.present? ? ordem.poco.cliente.pessoa.tipo ? 'cnpj' : 'cpf' : nil,
          iden: ordem.poco.cliente.pessoa.tipo.present? ? ordem.poco.cliente.pessoa.tipo ? ordem.poco.cliente.pessoa.pessoa_juridica.cnpj : ordem.poco.cliente.pessoa.pessoa_fisica.cpf : nil,
          celular: ordem.poco.cliente.pessoa.pessoas_contatos.last.try(:telefone_contato),
          telefone: ordem.poco.cliente.pessoa.telefone_principal,
          rg: ordem.poco.cliente.pessoa.tipo ? ordem.poco.cliente.pessoa.tipo ? nil : ordem.poco.cliente.pessoa.pessoa_fisica.rg : nil,
          rua: ordem.poco.cliente.pessoa.pessoa_endereco.present? ? ordem.poco.cliente.pessoa.pessoa_endereco.endereco : nil,
          bairro: ordem.poco.cliente.pessoa.pessoa_endereco.present? ? ordem.poco.cliente.pessoa.pessoa_endereco.bairro : nil,
          numero: ordem.poco.cliente.pessoa.pessoa_endereco.present? ? ordem.poco.cliente.pessoa.pessoa_endereco.numero : nil,
          complemento: ordem.poco.cliente.pessoa.pessoa_endereco.present? ? ordem.poco.cliente.pessoa.pessoa_endereco.complemento : nil,
          acesso_ao_poco: ordem.poco.instalacao.try(:acesso),
        },
        poco: {
          lat: ordem.poco.coordenada.try(:latitude),
          long: ordem.poco.coordenada.try(:longitude),
          zona: ordem.poco.coordenada.try(:zona),
          energia: ordem.poco.instalacao.try(:bomba).try(:energia).try(:descricao),
          instalacao: ordem.poco.instalacao.present? ? ordem.poco.instalacao : nil,
          modelo_bomba: ordem.poco.instalacao.present? && ordem.poco.instalacao.bomba.present? && ordem.poco.instalacao.bomba.modelo_bomba.present? ? ordem.poco.instalacao.bomba.modelo_bomba.descricao + ordem.poco.instalacao.bomba.estagio.descricao + ordem.poco.instalacao.bomba.motor.descricao + ordem.poco.instalacao.bomba.energia.descricao : nil,
          profundidade: ordem.poco.perfuracao.present? ? ordem.poco.perfuracao.profundidade : ordem.poco.profundidade,
          equipamentos: ordem.poco.instalacao.present? ? ordem.poco.instalacao.instalacao_poco_equipamentos.present? ? ordem.poco.instalacao.instalacao_poco_equipamentos.joins(:produto).where('produtos.exibir_app = true') : nil : nil,
          revestimento_quantidade: ordem.poco.revestimento_pocos.present? ? ordem.poco.revestimento_pocos[0].quantidade : nil,
          revestimento_tipo: ordem.poco.revestimento_pocos.present? && ordem.poco.revestimento_pocos[0].tipo_revestimento.present? ? ordem.poco.revestimento_pocos[0].tipo_revestimento.descricao : nil,
          observacao_bomba: ordem.poco.instalacao.present? && ordem.poco.instalacao.bomba.present? ? ordem.poco.instalacao.bomba.observacao : nil,
          qtd_cabo_sub: '',
          bitola_3x: '',
          bitola_poco: '',
          qtd_tubo: '',
          tipo_tubo: '',
        },
        other_services: ordem.other_services,
        servicos: ordem.ordem_servico_servicos.map do |ordem_servico|
          {
            id: ordem_servico.id,
            servico: {
              id:   ordem_servico.servico.id,
              nome: ordem_servico.servico.descricao,
            },
          }
        end,
        produtos: ordem.ordem_servico_produtos.map do |ordem_produto|
          {
            id:  ordem_produto.id,
            qtd: ordem_produto.qtd,
            produto: {
              id:   ordem_produto.produto.id,
              nome: ordem_produto.produto.descricao,
            },
          }
        end,
        manutencao: manutencao.present? ? {
            id: manutencao.id,
            poco_id: manutencao.poco_id,
            pessoa_contato: manutencao.pessoa_contato,
            telefone: manutencao.telefone,
            email: manutencao.email,
            servico: manutencao.servico.try(:id),
            numero_processo: manutencao.numero_processo,
            fotos: fotos,
            checklists: manutencao.manutencao_checklists
          } : false
      })
    end
    return ordens
  end

  def funcionarios
    funcionarios = []
    Funcionario.includes(:cargo, :pessoa).where(use_app: true).where('id != ?', current_user.funcionarios_id).each do |funcionario|
      funcionarios.push({
        id: funcionario.id,
        nome: funcionario.pessoa.nome,
        cargo: funcionario.cargo.try(:descricao)
      })
    end
    return funcionarios
  end

end