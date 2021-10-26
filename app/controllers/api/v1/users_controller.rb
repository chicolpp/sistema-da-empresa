module Api
  module V1
    class UsersController < APIController
      def all
        if params[:data] == 'blank'
          render json: Funcionario.find(@current_user.funcionarios_id), status: :ok, serializer: UserSerializer
        else
          render json: Funcionario.find(@current_user.funcionarios_id), status: :ok, serializer: UpdateUserSerializer, last_update: params[:data]
        end
      end

      def fotos
        archive = params['_id'].present? ? handle_picture! : nil
        if archive
          render json: {archive: archive.as_json}
        else
          render json: {archive: nil}
        end
      end

      def sync
        infos = params['_json']
        if infos['_id'].present?
          ordem = OrdemServico.find(infos['_id'])

          if ordem.present?
            pessoa = ordem.poco.cliente.pessoa

            if infos['statusId'].present?
              ordem.update(status: infos['statusId'], data_servico_realizado: infos['dataFinalizacao'])
            end

            if pessoa.present?

              if pessoa.pessoa_endereco.present?
                pessoa.pessoa_endereco.update(cidade_id: infos['cidade'], endereco: infos['rua'], numero: infos['numero'], complemento: infos['complemento'], bairro: infos['bairro'])
              else
                PessoaEndereco.create(pessoa_id: pessoa.id,cidade_id: infos['cidade'], endereco: infos['rua'], numero: infos['numero'], complemento: infos['complemento'], bairro: infos['bairro'])
              end
              if infos['cpfcnpj'] == 'cnpj'
                
                if pessoa.pessoa_juridica.present?
                  pessoa.pessoa_juridica.update(cnpj: infos['iden'])
                  if infos['nomeJuridica'] != '' && infos['nascimentoJuridica'] != '' && infos['telefoneJuridica'] != ''
                    if pessoa.pessoa_juridica.contato_juridica.present?
                      pessoa.pessoa_juridica.contato_juridica(nome_completo: infos['nomeJuridica'], data_de_nascimento: Time.parse(infos['nascimentoJuridica']), telefone: infos['telefoneJuridica'])
                    else
                      ContatoJuridica.create(pessoa_juridica_id: pessoa.pessoa_juridica.id, nome_completo: infos['nomeJuridica'], data_de_nascimento: Time.parse(infos['nascimentoJuridica']), telefone: infos['telefoneJuridica'])
                    end
                  end
                else
                  @pj = PessoaJuridica.create(pessoa_id: pessoa.id, cnpj: infos['iden'])
                  if infos['nomeJuridica'] != '' && infos['nascimentoJuridica'] != '' && infos['telefoneJuridica'] != ''
                    ContatoJuridica.create(pessoa_juridica_id: @pj.id, nome_completo: infos['nomeJuridica'], data_de_nascimento: Time.parse(infos['nascimentoJuridica']), telefone: infos['telefoneJuridica'])
                  end
                end
              else

                if pessoa.pessoa_fisica.present?
                  # pessoa.pessoa_fisica.update(cpf: infos['iden'], rg: infos['rg'], telefone_auxiliar_1: infos['telefone'], telefone_auxiliar_2: infos['celular'] )
                  pessoa.pessoa_fisica.update(cpf: infos['iden'], rg: infos['rg'].present? ? infos['rg'] : 'semRg', telefone_auxiliar_1: infos['tel_fixo'], telefone_auxiliar_2: infos['celular'] )
                else
                  PessoaFisica.create(pessoa_id: pessoa.id, cpf: infos['iden'], rg: infos['rg'].present? ? infos['rg'] : 'semRg', telefone_auxiliar_1: infos['tel_fixo'], telefone_auxiliar_2: infos['celular'] )
                end
              end
              if pessoa.pessoas_contatos.present?
                pessoa.pessoas_contatos.first.update(nome_contato: infos['nomeCompleto'], telefone_contato: infos['celular'])
              else
                pessoa.pessoas_contatos.create(nome_contato: infos['nomeCompleto'], telefone_contato: infos['celular'])
              end

              pessoa.update(
                nome: infos['nomeCompleto'],
              )
            end

            if ordem.poco.coordenada.present?
              ordem.poco.coordenada.update(longitude: infos['longitude'].to_s, latitude: infos['latitude'].to_s)
            else
              Coordenada.create(poco_id: ordem.poco.id, longitude: infos['longitude'].to_s, latitude: infos['latitude'].to_s)
            end


            if infos['acesso_poco_id'].present?
              acesso_poco_array = ['Ótimo', 'Bom', 'Satisfatório', 'Ruim', 'Péssimo']
              acesso = acesso_poco_array[infos['acesso_poco_id'].to_i]
            end

            # acesso = 'Acesso ao Poço: ' + infos['acesso_poco_id'].to_i == 0 ? 'Ótimo' : infos['acesso_poco_id'].to_i == 1 ? 'Bom' : infos['acesso_poco_id'].to_i == 2 ? 'Satisfatório' : infos['acesso_poco_id'].to_i == 3 ? 'Ruim' : 'Péssimo'

            if ordem.poco.instalacao
              ordem.poco.instalacao.update(acesso: infos['acesso_poco_id'].to_i, guincho: infos['nesGuinchoManual'] == true ? true : false)
            end

            manutencao = Manutencao.find_by(ordem_servico_id: ordem.id)
            if manutencao.present?
              manutencao.update(pessoa_contato: infos['nomeCompleto'], telefone: infos['celular'])

              dado_poco = {}
              dado_poco['produtosNaoListados'] = infos['produtosNaoListados'] if infos['produtosNaoListados'].present?

              serv = manutencao.manutencao_servicos.create(
                descricao:         infos['descricaoServicos'],
                data_servico:      infos['doneAt'].present? ? infos['doneAt'] : Time.current,
                tipo:              get_tipo_servico_code( ordem ),
                horas_trabalhadas: infos['horasTrabalhadas'],
                service_items:     infos[:serviceItems],
                step:              ordem.status_code,
                well_data:         dado_poco,
              )

              if infos['matUtilizados'].present?
                  infos['matUtilizados'].each do |mat|
                    serv.manutencao_servico_itens.create(produto_id: mat['produto_id'], quantidade: mat['quantidade'])
                  end
              end
              if infos['funcionarios'].present?
                infos['funcionarios'].each do |func|
                  serv.manutencao_funcionarios.create(funcionario_id: func['funcionario_id'].to_i)
                end
              end

              create_checklists!(ordem, manutencao, infos)

            else
              manut = Manutencao.create(
                poco_id:          ordem.poco.id,
                pessoa_contato:   infos['nomeCompleto'],
                telefone:         infos['celular'],
                servico_id:       infos['tipo'], # TODO: Verificar se o ID vem correto conforme o tipo selecionado pelo usuário
                ordem_servico_id: ordem.id
              )

              dado_poco = {}
              dado_poco['profunDoPoco']        = infos['profunDoPoco']        if infos['profunDoPoco'].present?
              dado_poco['profunDaBomba']       = infos['profunDaBomba']       if infos['profunDaBomba'].present?
              dado_poco['desnivel']            = infos['desnivel']            if infos['desnivel'].present?
              dado_poco['distPocoRes']         = infos['distPocoRes']         if infos['distPocoRes'].present?
              dado_poco['ltsRes']              = infos['ltsRes']              if infos['ltsRes'].present?
              dado_poco['qntCaboSub']          = infos['qntCaboSub']          if infos['qntCaboSub'].present?
              dado_poco['bitola3x']            = infos['bitola3x']            if infos['bitola3x'].present?
              dado_poco['bitolaDoPoco']        = infos['bitolaDoPoco']        if infos['bitolaDoPoco'].present?
              dado_poco['qntTubo']             = infos['qntTubo']             if infos['qntTubo'].present?
              dado_poco['tipoTubo']            = infos['tipoTubo']            if infos['tipoTubo'].present?
              dado_poco['modeloBomba']         = infos['modeloBomba']         if infos['modeloBomba'].present?
              dado_poco['bombaVolts']          = infos['bombaVolts']          if infos['bombaVolts'].present?
              dado_poco['produtosNaoListados'] = infos['produtosNaoListados'] if infos['produtosNaoListados'].present?

              serv = manut.manutencao_servicos.create(
                descricao:         infos['descricaoServicos'],
                data_servico:      infos['doneAt'].present? ? infos['doneAt'] : Time.current,
                tipo:              get_tipo_servico_code( ordem ),
                horas_trabalhadas: infos['horasTrabalhadas'],
                well_acess:        acesso,
                well_data:         dado_poco,
                service_items:     infos[:serviceItems],
                step:              ordem.status_code
              )

              if infos['matUtilizados'].present?
                infos['matUtilizados'].each do |mat|
                  serv.manutencao_servico_itens.create(produto_id: mat[:produto_id], quantidade: mat[:quantidade])
                end
              end

              if infos['funcionarios'].present?
                infos['funcionarios'].each do |func|
                  serv.manutencao_funcionarios.create(funcionario_id: func[:funcionario_id])
                end
              end

              create_checklists!(ordem, manut, infos)
            end
          end
        end
        render json: {ok: true}
      end

      private

      def handle_picture!
        archive = Arquivo.where("uuid is not null and uuid != ''").find_by(uuid: params[:uuid], owner_id: params['_id'])
        return archive if archive

        ordem_servico = OrdemServico.find_by(id: params['_id'])

        if manutencao = Manutencao.find_by(ordem_servico_id: params['_id'])
          if params['comentario'].present? && params['comentario'] != "\"\""
            manutencao.arquivos.create(
              upload: params['upload'],
              nome: params['name'],
              comentarios: params['comentario'],
              album: params['album'],
              uuid: params[:uuid],
              step: OrdemServico.statuses[ordem_servico.try(:status)]
            )
          else
            manutencao.arquivos.create(
              upload: params['upload'],
              nome: params['name'],
              album: params['album'],
              uuid: params[:uuid],
              step: OrdemServico.statuses[ordem_servico.try(:status)]
            )
          end
        end
      end

      def create_checklists!(ordem, manut, infos)
        if infos['isBombaEmprestada'] == true
          manut.manutencao_checklists.create(step: ordem.status_code, nome: 'Bomba Emprestada', descricao: infos['bombaEmprestada'], observacoes: infos['bombaEmprestadaInfo'])
        end

        if infos['isTrocaDeTubos'] == true
          manut.manutencao_checklists.create(step: ordem.status_code, nome: 'Troca de Tubo', descricao: infos['trocaDeTubos'], observacoes: infos['trocaDeTubosInfo'])
        end
        if infos['isLimpezaDoPoco'] == true
          manut.manutencao_checklists.create(step: ordem.status_code, nome: 'Fazer limpeza do Poço', descricao: 'SIM', observacoes: infos['limpezaDoPocoInfo'])
        end
        if infos['isTrocaCaboSubmersivel'] == true
          manut.manutencao_checklists.create(step: ordem.status_code, nome: 'Troca Cabo Submersível', descricao: infos['trocaCaboSubmersivel'], observacoes: infos['trocaDoCaboSubmersivelInfo'])
        end
        if infos['manutDoQuadro'] == true
          manut.manutencao_checklists.create(step: ordem.status_code, nome: 'Manutenção do Quadro', descricao: 'SIM', observacoes: infos['manutDoQuadroInfo'])
        end
        if infos['nesGuinchoManual'] == true

          if infos['testeVazao'] == true
            manut.manutencao_checklists.create(
              step: ordem.status_code,
              nome: 'Fazer teste de Vazão',
              descricao: 'SIM',
              observacoes: infos['testeVazaoInfo'].present? ? infos['testeVazaoInfo'] : nil
            )
          end

          if infos['energiaCliente'] == true
            manut.manutencao_checklists.create(
              step: ordem.status_code,
              nome: 'Utilizei energia do Cliente',
              descricao: 'SIM',
              observacoes: infos['energiaClienteInfo'].present? ? infos['energiaClienteInfo'] : nil
            )
          end

          manut.manutencao_checklists.create(step: ordem.status_code, nome: 'Necessário guincho manual', descricao: 'SIM', observacoes: infos['nesGuinchoManualInfo'])
        end

        if infos['indicInfiltra'] == true
          manut.manutencao_checklists.create(step: ordem.status_code, nome: 'Poço tem indício de infiltração', descricao: 'SIM', observacoes: infos['indicInfiltraInfo'])
        end

        if infos['limpezaReservatorio'] == true
          manut.manutencao_checklists.create(step: ordem.status_code, nome: 'Fazer limpeza do Reservatório', descricao: 'SIM', observacoes: infos['limpezaReservatorioInfo'])
        end

        if infos['oferecerManutPreventiva'] == true
          manut.manutencao_checklists.create(step: ordem.status_code, nome: 'Oferece manutenção preventiva', descricao: 'SIM', observacoes: infos['oferecerManutPreventivaInfo'])
        end
      end


      def get_tipo_servico_code(ordem_servico)
        case OrdemServico.statuses[ordem_servico.status]
        when 1, 2
          0
        when 3, 4
          1
        else
          2
        end
      end

    end
  end
end


