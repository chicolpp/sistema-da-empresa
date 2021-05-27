# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20210527172950) do

  create_table "alertas", force: true do |t|
    t.text     "descricao"
    t.datetime "exibir_ate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "titulo"
  end

  create_table "aprofundamento_funcionarios", force: true do |t|
    t.integer  "aprofundamento_id"
    t.integer  "funcionario_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "aprofundamentos", force: true do |t|
    t.date     "data_inicio"
    t.date     "data_fim"
    t.integer  "poco_id"
    t.string   "profundidade_nova"
    t.integer  "bitola_id"
    t.integer  "maquina_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "observacao"
  end

  create_table "arquivos", force: true do |t|
    t.string   "upload_file_name"
    t.string   "upload_content_type"
    t.integer  "upload_file_size"
    t.datetime "upload_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "nome"
    t.text     "comentarios"
    t.string   "album"
  end

  create_table "assistencia_posvendas", force: true do |t|
    t.integer  "cliente_id"
    t.integer  "admin_user_id"
    t.integer  "pergunta1"
    t.string   "pergunta1_outros"
    t.integer  "pergunta2"
    t.integer  "pergunta3"
    t.string   "pergunta3_motivo"
    t.integer  "pergunta4"
    t.string   "pergunta4_motivo"
    t.integer  "pergunta5"
    t.string   "pergunta5_motivo"
    t.integer  "pergunta6"
    t.string   "pergunta6_motivo"
    t.integer  "pergunta7"
    t.integer  "pergunta8"
    t.integer  "pergunta9"
    t.string   "pergunta9_motivo"
    t.string   "pergunta10"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "audits", force: true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         default: 0
    t.string   "comment"
    t.string   "remote_address"
    t.string   "request_uuid"
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], name: "associated_index", using: :btree
  add_index "audits", ["auditable_id", "auditable_type"], name: "auditable_index", using: :btree
  add_index "audits", ["created_at"], name: "index_audits_on_created_at", using: :btree
  add_index "audits", ["request_uuid"], name: "index_audits_on_request_uuid", using: :btree
  add_index "audits", ["user_id", "user_type"], name: "user_index", using: :btree

  create_table "bitolas", force: true do |t|
    t.string   "descricao"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bombas", force: true do |t|
    t.text     "observacao"
    t.integer  "modelo_bomba_id"
    t.integer  "estagio_id"
    t.integer  "hp_id"
    t.integer  "energia_id"
    t.integer  "motor_id"
    t.integer  "bombeador_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "instalacao_id"
  end

  create_table "bombeadores", force: true do |t|
    t.text     "descricao"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cargos", force: true do |t|
    t.string   "descricao"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "casein_admin_users", force: true do |t|
    t.string   "login",                           null: false
    t.string   "name"
    t.string   "email"
    t.integer  "access_level",        default: 0, null: false
    t.string   "crypted_password",                null: false
    t.string   "password_salt",                   null: false
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.integer  "login_count",         default: 0, null: false
    t.integer  "failed_login_count",  default: 0, null: false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.string   "time_zone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pessoa_id"
    t.string   "cargo"
    t.string   "telefone1"
    t.string   "telefone2"
    t.integer  "cidade_id"
    t.boolean  "pos_venda"
  end

  create_table "cidades", force: true do |t|
    t.string  "nome",      null: false
    t.integer "estado_id", null: false
  end

  create_table "ckeditor_assets", force: true do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "clientes", force: true do |t|
    t.integer  "pessoa_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contato_juridicas", force: true do |t|
    t.string   "nome_completo"
    t.string   "telefone"
    t.date     "data_de_nascimento"
    t.integer  "pessoa_juridica_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contato_juridicas", ["pessoa_juridica_id"], name: "index_contato_juridicas_on_pessoa_juridica_id", using: :btree

  create_table "coordenadas", force: true do |t|
    t.string   "longitude"
    t.string   "latitude"
    t.string   "zona"
    t.integer  "poco_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "energias", force: true do |t|
    t.text     "descricao"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entradas_agua", force: true do |t|
    t.string   "metragem"
    t.string   "vazao_aproximada"
    t.integer  "poco_id"
    t.integer  "aprofundamento_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "estados", force: true do |t|
    t.string "nome",  null: false
    t.string "sigla", null: false
  end

  create_table "estagios", force: true do |t|
    t.text     "descricao"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fornecedores", force: true do |t|
    t.integer  "pessoa_id",    null: false
    t.string   "nome_contato"
    t.string   "cargo"
    t.text     "observacoes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fotos", force: true do |t|
    t.integer  "casein_admin_user_id"
    t.string   "foto_file_name"
    t.string   "foto_content_type"
    t.integer  "foto_file_size"
    t.datetime "foto_updated_at"
    t.string   "observacao"
    t.integer  "status",               default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "poco_id"
    t.string   "nome"
  end

  create_table "funcionarios", force: true do |t|
    t.integer  "pessoa_id",             null: false
    t.integer  "cargo_id"
    t.string   "carteira_profissional"
    t.date     "data_admissao"
    t.date     "data_demissao"
    t.text     "curriculo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "use_app"
    t.string   "email"
  end

  create_table "hps", force: true do |t|
    t.text     "descricao"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "instalacao_adutora_equipamentos", force: true do |t|
    t.integer  "instalacao_id"
    t.integer  "produto_id"
    t.integer  "quantidade"
    t.string   "observacao"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "instalacao_distribuicao_equipamentos", force: true do |t|
    t.integer  "instalacao_id"
    t.integer  "produto_id"
    t.integer  "quantidade"
    t.string   "observacao"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "instalacao_funcionarios", force: true do |t|
    t.integer  "instalacao_id"
    t.integer  "funcionario_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "instalacao_poco_equipamentos", force: true do |t|
    t.integer  "instalacao_id"
    t.integer  "produto_id"
    t.integer  "quantidade"
    t.string   "observacao"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "instalacoes", force: true do |t|
    t.integer  "poco_id"
    t.integer  "acesso"
    t.boolean  "guincho"
    t.string   "profundidade_bomba"
    t.string   "vazao_bomba"
    t.string   "nivel_dinamico"
    t.string   "perca_carga"
    t.string   "altura_nanometrica"
    t.string   "desnivel"
    t.string   "nivel_estatico"
    t.string   "distancia_poco_caixa"
    t.integer  "aprofundamento_id"
    t.boolean  "possui_instalacao"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "periodo_manutencao"
    t.date     "data_instalacao_inicio"
  end

  create_table "manutencao_checklists", force: true do |t|
    t.string   "nome"
    t.string   "descricao"
    t.string   "observacoes"
    t.integer  "manutencao_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "manutencao_contatos", force: true do |t|
    t.integer  "poco_id"
    t.integer  "manutencao_servico"
    t.text     "observacao"
    t.date     "nova_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "manutencao_funcionarios", force: true do |t|
    t.integer  "funcionario_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "manutencao_servico_id"
  end

  create_table "manutencao_produtos", force: true do |t|
    t.integer  "manutencao_id"
    t.integer  "produto_id"
    t.string   "quantidade"
    t.string   "observacao"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "manutencao_servico_itens", force: true do |t|
    t.integer  "manutencao_servico_id"
    t.integer  "produto_id"
    t.string   "quantidade"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "manutencao_servicos", force: true do |t|
    t.integer  "manutencao_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tipo"
    t.string   "descricao"
    t.date     "data_servico"
    t.integer  "horas_trabalhadas"
  end

  create_table "manutencaos", force: true do |t|
    t.integer  "poco_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pessoa_contato"
    t.string   "telefone"
    t.string   "email"
    t.integer  "servico_id"
    t.string   "numero_processo"
    t.integer  "vendedor_id"
    t.integer  "ordem_servico_id"
  end

  create_table "maquinas", force: true do |t|
    t.string   "descricao"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "marcas", force: true do |t|
    t.string   "descricao"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "modelo_bombas", force: true do |t|
    t.text     "descricao"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "motores", force: true do |t|
    t.text     "descricao"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", force: true do |t|
    t.string   "title"
    t.string   "link"
    t.integer  "vendedor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "status"
  end

  create_table "orcamento_itens", force: true do |t|
    t.integer  "orcamento_id"
    t.string   "quantidade"
    t.string   "descricao"
    t.string   "preco_unitario"
    t.string   "preco_total"
    t.string   "unidade"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orcamentos", force: true do |t|
    t.integer  "cliente_id"
    t.date     "data_proposta"
    t.integer  "casein_admin_user_id"
    t.string   "validade_proposta"
    t.string   "prazo_inicio"
    t.string   "prazo_execucao"
    t.string   "condicao_pagamento"
    t.string   "descricao"
    t.string   "cidade_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ordem_servicos", force: true do |t|
    t.date     "abertura"
    t.integer  "status"
    t.text     "observacoes"
    t.integer  "poco_id"
    t.integer  "funcionario_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.text     "sintoma"
    t.date     "data_servico_realizado"
    t.date     "data_proxima_etapa"
  end

  add_index "ordem_servicos", ["funcionario_id"], name: "index_ordem_servicos_on_funcionario_id", using: :btree
  add_index "ordem_servicos", ["poco_id"], name: "index_ordem_servicos_on_poco_id", using: :btree

  create_table "perfuracao_funcionarios", force: true do |t|
    t.integer  "perfuracao_id"
    t.integer  "funcionario_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "perfuracao_posvendas", force: true do |t|
    t.integer  "cliente_id"
    t.integer  "admin_user_id"
    t.integer  "pergunta1"
    t.string   "pergunta1_outros"
    t.integer  "pergunta2"
    t.integer  "pergunta3"
    t.string   "pergunta3_email"
    t.integer  "pergunta4"
    t.string   "pergunta4_motivo"
    t.integer  "pergunta5"
    t.string   "pergunta5_motivo"
    t.integer  "pergunta6"
    t.integer  "pergunta7"
    t.integer  "pergunta8"
    t.string   "pergunta8_motivo"
    t.string   "pergunta8_cliente"
    t.string   "pergunta9"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "perfuracoes", force: true do |t|
    t.integer  "poco_id"
    t.string   "profundidade"
    t.integer  "maquina_id"
    t.integer  "bitola_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "data_perfuracao_inicio"
    t.date     "data_perfuracao_fim"
  end

  create_table "pessoas", force: true do |t|
    t.string   "nome",                              null: false
    t.boolean  "tipo"
    t.boolean  "recebe_email",       default: true
    t.boolean  "recebe_sms",         default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email_contato"
    t.string   "email_xml"
    t.string   "telefone_principal"
    t.string   "uuid"
  end

  create_table "pessoas_classificacoes", force: true do |t|
    t.integer  "classificacao"
    t.integer  "pessoa_id",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pessoas_contatos", force: true do |t|
    t.integer  "pessoa_id",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nome_contato"
    t.string   "email_contato"
    t.date     "data_nascimento_contato"
    t.string   "telefone_contato"
  end

  create_table "pessoas_dados_bancarios", force: true do |t|
    t.integer  "nome_banco"
    t.string   "agencia"
    t.string   "conta"
    t.integer  "pessoa_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pessoas_enderecos", force: true do |t|
    t.integer  "tipo_endereco"
    t.string   "cep"
    t.string   "endereco"
    t.string   "numero"
    t.string   "complemento"
    t.string   "bairro"
    t.integer  "cidade_id"
    t.integer  "cidade_natal_id"
    t.integer  "pessoa_id",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pessoas_fisicas", force: true do |t|
    t.string   "cpf"
    t.string   "rg"
    t.date     "data_nascimento"
    t.integer  "estado_civil"
    t.boolean  "sexo"
    t.integer  "pessoa_id",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "telefone_auxiliar_1"
    t.string   "telefone_auxiliar_2"
    t.string   "telefone_auxiliar_3"
  end

  create_table "pessoas_juridicas", force: true do |t|
    t.string   "cnpj"
    t.string   "ie"
    t.string   "im"
    t.date     "data_fundacao"
    t.integer  "pessoa_id",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nome_fantasia"
  end

  create_table "pocos", force: true do |t|
    t.boolean  "poco_produtivo"
    t.integer  "cliente_id"
    t.string   "linha_endereco"
    t.string   "apelido_endereco"
    t.boolean  "perfuracao_leao"
    t.integer  "cidade_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "observacao"
    t.string   "numero_processo"
    t.string   "profundidade"
    t.integer  "periodo_manutencao"
  end

  create_table "pos_vendas", force: true do |t|
    t.integer  "cliente_id"
    t.string   "resposta1"
    t.string   "resposta2"
    t.string   "resposta3"
    t.string   "resposta4"
    t.string   "resposta5"
    t.string   "resposta6"
    t.string   "resposta7"
    t.string   "resposta8"
    t.string   "resposta9"
    t.string   "resposta10"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "produtos", force: true do |t|
    t.string   "descricao"
    t.integer  "marca_id"
    t.string   "unidade_medida_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "exibir_app"
    t.string   "uuid"
  end

  create_table "revestimento_pocos", force: true do |t|
    t.string   "quantidade"
    t.integer  "tipo_revestimento_id"
    t.integer  "poco_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "polegadas"
  end

  create_table "revestimento_pocos_bitola", force: true do |t|
    t.integer  "revestimento_poco_id"
    t.integer  "bitola_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "servicos", force: true do |t|
    t.string   "descricao"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid"
  end

  create_table "tipo_revestimentos", force: true do |t|
    t.string   "descricao"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "unidades_medidas", force: true do |t|
    t.string   "descricao"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_apps", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.integer  "funcionarios_id",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",          default: false
  end

  create_table "usuario_cidades", force: true do |t|
    t.integer  "cidade_id"
    t.integer  "admin_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vazao_agua_funcionarios", force: true do |t|
    t.integer  "vazao_agua_id"
    t.integer  "funcionario_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vazoes_agua", force: true do |t|
    t.string   "vazao_teste"
    t.string   "vazao_dinamico"
    t.string   "nivel_estatico"
    t.string   "recuperacao"
    t.integer  "poco_id"
    t.integer  "aprofundamento_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "possui_vazao",       default: true
    t.text     "observacao"
    t.date     "data_teste"
    t.string   "profundidade_bomba"
  end

end
