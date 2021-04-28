Rails.application.routes.draw do

	namespace :api do
		namespace :v1 do
			post 'authenticate', to: 'authentication#authenticate'
			get 'auth/validate_token', to: 'authentication#auth_token'
			get 'ordem/:id', to: 'ordem#index'
			get 'produtos', to: 'produtos#index'
			get 'all/:data', to: 'users#all'
			post 'sync', to: 'users#sync'
			post 'sync/fotos', to: 'users#fotos'

		end
	end
	mount Ckeditor::Engine => '/ckeditor'
	#Casein routes
	namespace :casein do
		resources :manutencao_contatos
		resources :notifications
		resources :fotos
		resources :assistencia_posvendas
		resources :perfuracao_posvendas
		resources :alertas
		resources :manutencao_servico_itens
		resources :admin_users do
			member do
					patch :update_password, :reset_password
			end
      get "filtro_ajax"
    end
		resources :usuario_cidades do
			get "cadastro_ajax"
		end
		resources :orcamento_itens do
			get "cadastro_ajax"
		end
		resources :orcamentos do
			get "imprimir"
			get "filtro_ajax"
		end
		resources :manutencao_funcionarios
		resources :manutencaos do
			get "filtro_ajax"
			get "filtro_relatorio"
			post "filtro_relatorio"
			get "alerta_email_vendedor"
		end
		resources :manutencao_produtos do
			get "cadastro_ajax"
		end
		resources :manutencao_servicos
		resources :servicos
		resources :aprofundamento_funcionarios
		resources :aprofundamentos do
			get "filtro_ajax"
		end
		resources :instalacao_poco_equipamentos
		resources :instalacao_adutora_equipamentos
		resources :instalacao_distribuidora_equipamentos do
			# get "cadastro_ajax"
		end
		resources :produtos
		resources :unidades_medidas
		resources :marcas
		resources :instalacao_funcionarios
		resources :instalacoes do
			get "filtro_relatorio"
			post "filtro_relatorio"
		end
		resources :arquivos
		resources :vazao_agua_funcionarios
		resources :perfuracao_funcionarios
		resources :cargos do
			get "filtro_ajax"
		end
		resources :entradas_agua
		resources :entrada_aguas
		resources :vazoes_agua do
			get "filtro_ajax"
		end
		resources :vazao_aguas
		resources :revestimento_pocos_bitola
		resources :tipo_revestimentos
		resources :revestimento_pocos
		resources :coordenadas
		resources :pocos do
			get "filtro_ajax"
			get "filtro_relatorio"
			post "filtro_relatorio"
			get "relatorio_detalhes"
			get "relatorio_assistencias"
		end
		resources :bitolas
		resources :maquinas
		resources :perfuracoes
		resources :energias
		resources :modelo_bombas
		resources :hps
		resources :estagios
		resources :bombeadores
		resources :motores
		resources :bombas do
			get "filtro_ajax"
		end
		resources :clientes do
			get "filtro_relatorio"
			post "filtro_relatorio"
		end
		resources :fornecedores
		resources :funcionarios
		resources :pessoas_classificacoes, :except => [:index]
		resources :pessoas_contatos, :except => [:index]
		resources :pessoas_enderecos, :except => [:index]
		resources :pessoas_dados_bancarios, :except => [:index]
		resources :pessoas_juridicas, :except => [:index]
		resources :pessoas_fisicas, :except => [:index]
		resources :pessoas do
			get "filtro_ajax"
			get "aniversariantes"
		end


		resources :ordem_servicos
		match 'atualizar/status'		=> 'ordem_servicos#atualizar_status',		as: :atualizar_status,    via: [:get, :post]
		match 'manutencao/arquivo'  => 'manutencaos#new_arquivo',     			as: :new_arquivo,    			via: [:get, :post]
		match 'manutencao/new_arquivo'	=> 'manutencaos#new_arquivo_show',			as: :new_arquivo_show, 		via: [:get, :post]
		match 'manutencao/new_arquivo_manut' => 'manutencaos#new_arquivo_show_manut', as: :new_arquivo_show_manut, via: [:get, :post]
		get 'relatorio/processos' => 'pocos#relatorio_processos',       as: :relatorio_processos
		get 'relatorio/sugestoes' => 'relatorios#sugestoes_pos_vendas', as: :sugestoes_pos_vendas
		get 'relatorio/graficos'  => 'relatorios#graficos_pos_vendas',  as: :graficos_pos_vendas
		get 'dashboard' => 'dashboard#index', as: :dashboard
	end

	root 'home#index'

	match "/" => redirect("/casein"), :via => :get
	get  'ajax/carregar/cidades' => "home#carregar_cidades", as: :carregar_cidades
	get  'get_cidades', to: 'home#get_cidades', as: :get_cidades
	get  'ajax/carregar/pocos' => "home#carregar_pocos", as: :carregar_pocos
	get  'ajax/carregar/dados_poco' => "home#carregar_dados_poco", as: :carregar_dados_poco
	get  'ajax/maquinas/adicionar' => "casein/maquinas#adicionar", as: :adicionar_maquinas
	get  'ajax/bitolas/adicionar' => "casein/bitolas#adicionar", as: :adicionar_bitolas
	get  'ajax/produtos/adicionar' => "casein/produtos#adicionar", as: :adicionar_produtos
	get  'ajax/funcionarios/adicionar' => "casein/funcionarios#adicionar", as: :adicionar_funcionarios
	get  'ajax/modelo-bombas/adicionar' => "casein/modelo_bombas#adicionar", as: :adicionar_modelo_bombas
	get  'ajax/energia/adicionar' => "casein/energias#adicionar", as: :adicionar_energias
	get  'ajax/motor/adicionar' => "casein/motores#adicionar", as: :adicionar_motores
	get  'ajax/estagio/adicionar' => "casein/estagios#adicionar", as: :adicionar_estagios
end