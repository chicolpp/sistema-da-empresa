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
              acesso = '<b>Acesso ao Poço : </b>' + acesso_poco_array[infos['acesso_poco_id'].to_i]
            end

            # acesso = 'Acesso ao Poço: ' + infos['acesso_poco_id'].to_i == 0 ? 'Ótimo' : infos['acesso_poco_id'].to_i == 1 ? 'Bom' : infos['acesso_poco_id'].to_i == 2 ? 'Satisfatório' : infos['acesso_poco_id'].to_i == 3 ? 'Ruim' : 'Péssimo'

            if ordem.poco.instalacao
              ordem.poco.instalacao.update(acesso: infos['acesso_poco_id'].to_i, guincho: infos['nesGuinchoManual'] == true ? true : false)
            end

            manutencao = Manutencao.find_by(ordem_servico_id: ordem.id)
            if manutencao.present?
              manutencao.update(pessoa_contato: infos['nomeCompleto'], telefone: infos['celular'])
              serv = manutencao.manutencao_servicos.create(
                tipo: 0,
                descricao:         infos['descricaoServicos'],
                data_servico:      infos['doneAt'].present? ? infos['doneAt'] : Time.current,
                tipo:              infos['status'] == 'Finalização' ? 2 : infos['status'] == 'Início' ? 0 : 1,
                horas_trabalhadas: infos['horasTrabalhadas'],
                service_items:     infos[:serviceItems]
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

            else
              manut = Manutencao.create(
                poco_id: ordem.poco.id,
                pessoa_contato: infos['nomeCompleto'],
                telefone: infos['celular'],
                servico_id: infos['tipo'],
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

              # if infos['profunDoPoco'] != ''
              #   dado_poco << '<b>Profundidade : </b>' + infos['profunDoPoco'] + ' <br> '
              # end
              # if infos['profunDaBomba'] != ''
              #   dado_poco <<  '<b>Profundidade da bomba : </b>' + infos['profunDaBomba'] + ' <br> '
              # end
              # if infos['desnivel'] != ''
              #   dado_poco << '<b>Desnível : </b>' + infos['desnivel'] + ' <br> '
              # end
              # if infos['distPocoRes'] != ''
              #   dado_poco << '<b>Distância do poço até o reservatório : </b>' + infos['distPocoRes'] + ' <br> '
              # end
              # if infos['ltsRes'] != ''
              #   dado_poco << '<b>Capacidade do reservatório : </b>' + infos['ltsRes'] + 'litros' + ' <br> '
              # end
              # if infos['qntCaboSub'] != ''
              #   dado_poco << '<b>Quantidade de cabos submersíveis : </b>' + infos['qntCaboSub'] + ' <br> '
              # end
              # if infos['bitola3x'] != ''
              #   dado_poco << '<b>Quantidade de bitola 3x : </b>' + infos['bitola3x'] + ' <br> '
              # end
              # if infos['bitolaDoPoco'] != ''
              #   dado_poco << '<b>Quantidade do poço : </b>' + infos['bitolaDoPoco'] + ' <br> '
              # end
              # if infos['qntTubo'] != ''
              #   dado_poco << '<b>Quantidade de tubo : </b>' + infos['qntTubo'] + ' <br> '
              # end
              # if infos['tipoTubo'] != ''
              #   dado_poco << '<b>Tipo do tubo : </b>' + infos['tipoTubo'] + ' <br> '
              # end
              # if infos['modeloBomba'] != ''
              #   dado_poco << '<b>Modelo da bomba : </b>' + infos['modeloBomba'] + ' <br> '
              # end

              # if infos['produtosNaoListados'] != ''
              #   dado_poco << '<b>Produtos não listados : </b>' + infos['produtosNaoListados'] + ' <br> '
              # end

              serv = manut.manutencao_servicos.create(
                tipo:              0,
                descricao:         infos['descricaoServicos'],
                data_servico:      infos['doneAt'].present? ? infos['doneAt'] : Time.current,
                tipo:              infos['status'] == 'Finalização' ? 2 : infos['status'] == 'Início' ? 0 : 1,
                horas_trabalhadas: infos['horasTrabalhadas'],
                well_acess:        acesso,
                well_data:         dado_poco,
                service_items:     infos[:serviceItems]
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

              if infos['isBombaEmprestada'] == true
                manut.manutencao_checklists.create(nome: 'Bomba Emprestada', descricao: infos['bombaEmprestada'], observacoes: infos['bombaEmprestadaInfo'])
              end

              if infos['isTrocaDeTubos'] == true
                manut.manutencao_checklists.create(nome: 'Troca de Tubo', descricao: infos['trocaDeTubos'], observacoes: infos['trocaDeTubosInfo'])
              end
              if infos['isLimpezaDoPoco'] == true
                manut.manutencao_checklists.create(nome: 'Fazer limpeza do Poço', descricao: 'SIM', observacoes: infos['limpezaDoPocoInfo'])
              end
              if infos['isTrocaCaboSubmersivel'] == true
                manut.manutencao_checklists.create(nome: 'Troca Cabo Submersível', descricao: infos['trocaCaboSubmersivel'], observacoes: infos['trocaDoCaboSubmersivelInfo'])
              end
              if infos['manutDoQuadro'] == true
                manut.manutencao_checklists.create(nome: 'Manutenção do Quadro', descricao: 'SIM', observacoes: infos['manutDoQuadroInfo'])
              end
              if infos['nesGuinchoManual'] == true

                if infos['testeVazao'] == true
                  manut.manutencao_checklists.create(
                    nome: 'Fazer teste de Vazão',
                    descricao: 'SIM',
                    observacoes: infos['testeVazaoInfo'].present? ? infos['testeVazaoInfo'] : nil
                  )
                end

                if infos['energiaCliente'] == true
                  manut.manutencao_checklists.create(
                    nome: 'Utilizei energia do Cliente',
                    descricao: 'SIM',
                    observacoes: infos['energiaClienteInfo'].present? ? infos['energiaClienteInfo'] : nil
                  )
                end

                manut.manutencao_checklists.create(nome: 'Necessário guincho manual', descricao: 'SIM', observacoes: infos['nesGuinchoManualInfo'])
              end

              if infos['indicInfiltra'] == true
                manut.manutencao_checklists.create(nome: 'Poço tem indício de infiltração', descricao: 'SIM', observacoes: infos['indicInfiltraInfo'])
              end

              if infos['limpezaReservatorio'] == true
                manut.manutencao_checklists.create(nome: 'Fazer limpeza do Reservatório', descricao: 'SIM', observacoes: infos['limpezaReservatorioInfo'])
              end

              if infos['oferecerManutPreventiva'] == true
                manut.manutencao_checklists.create(nome: 'Oferece manutenção preventiva', descricao: 'SIM', observacoes: infos['oferecerManutPreventivaInfo'])
              end
            end
          end
        end
        render json: {ok: true}
      end

      private

      def handle_picture!
        archive = Arquivo.where("uuid is not null and uuid != ''").find_by(uuid: params[:uuid], owner_id: params['_id'])
        return archive if archive

        if manutencao = Manutencao.find_by(ordem_servico_id: params['_id'])
          if params['comentario'].present? && params['comentario'] != "\"\""
            manutencao.arquivos.create(
              upload: params['upload'],
              nome: params['name'],
              comentarios: params['comentario'],
              album: params['album'],
              uuid: params[:uuid]
            )
          else
            manutencao.arquivos.create(
              upload: params['upload'],
              nome: params['name'],
              album: params['album'],
              uuid: params[:uuid]
            )
          end
        end
      end
    end
  end
end


