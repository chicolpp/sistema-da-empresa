class UpdateUserSerializer < ActiveModel::Serializer
  attributes :id, :email, :produtos, :ordens, :funcionarios

  def produtos
    return Produto.where('updated_at > ?', instance_options[:last_update])
  end

  def ordens
    ordens = []
    object.ordem_servicos.where('status = 1 or status = 4').where('updated_at > ?', instance_options[:last_update]).each do |ordem|
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
          instalacao: ordem.poco.instalacao.present? ? ordem.poco.instalacao : nil,
          modelo_bomba: ordem.poco.instalacao.present? && ordem.poco.instalacao.bomba.present? && ordem.poco.instalacao.bomba.modelo_bomba.present? ? ordem.poco.instalacao.bomba.modelo_bomba.descricao + ordem.poco.instalacao.bomba.estagio.descricao + ordem.poco.instalacao.bomba.motor.descricao + ordem.poco.instalacao.bomba.energia.descricao : nil,
          profundidade: ordem.poco.perfuracao.present? ? ordem.poco.perfuracao.profundidade : nil,
          equipamentos: ordem.poco.instalacao.present? ? ordem.poco.instalacao.instalacao_poco_equipamentos.present? ? ordem.poco.instalacao.instalacao_poco_equipamentos.joins(:produto).where('produtos.exibir_app = true') : nil : nil,
          revestimento_quantidade: ordem.poco.revestimento_pocos.present? ? ordem.poco.revestimento_pocos[0].quantidade : nil,
          revestimento_tipo: ordem.poco.revestimento_pocos.present? && ordem.poco.revestimento_pocos[0].tipo_revestimento.present? ? ordem.poco.revestimento_pocos[0].tipo_revestimento.descricao : nil,
          observacao_bomba: ordem.poco.instalacao.present? && ordem.poco.instalacao.bomba.present? ? ordem.poco.instalacao.bomba.observacao : nil,
        },
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
    Funcionario.where(use_app: true).where('id != ?', current_user.funcionarios_id).where('updated_at > ?', instance_options[:last_update]).each do |funcionario|
      funcionarios.push({
        id: funcionario.id,
        nome: funcionario.pessoa.nome,
        cargo: funcionario.cargo.try(:descricao)
      })
    end
    return funcionarios
  end

end