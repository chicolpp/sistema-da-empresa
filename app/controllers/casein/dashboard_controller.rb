module Casein
	class DashboardController < Casein::CaseinController
		def index
			@assistencias_admin = Manutencao.select("id, created_at").where("created_at >= '#{6.month.ago.at_end_of_month}'").order(created_at: :desc).all
			@pocos_admin = Poco.select("id, created_at").where("created_at >= '#{6.month.ago.at_end_of_month}'").order(created_at: :desc).all

  		@pocos_manutencao_admin = Poco.select("pocos.id, pocos.cliente_id, pocos.linha_endereco, pocos.apelido_endereco, data_servico, DATE_SUB(NOW(), INTERVAL 3 YEAR), pocos.periodo_manutencao").joins("LEFT JOIN manutencaos m ON m.poco_id = pocos.id LEFT JOIN manutencao_servicos ms ON ms.manutencao_id = m.id").joins(:instalacao).where("ms.data_servico < DATE_SUB(NOW(), INTERVAL pocos.periodo_manutencao YEAR)").group("pocos.id").order("ms.data_servico DESC")

  		@pocos_manutencao_admin_data_atual = Poco.select("pocos.id, pocos.cliente_id, pocos.linha_endereco, pocos.apelido_endereco, data_servico, DATE_SUB(NOW(), INTERVAL 3 YEAR), pocos.periodo_manutencao").joins("LEFT JOIN manutencaos m ON m.poco_id = pocos.id LEFT JOIN manutencao_servicos ms ON ms.manutencao_id = m.id").joins(:instalacao).joins("LEFT JOIN manutencao_contatos mc on mc.poco_id = pocos.id ").where("mc.nova_data = DATE('#{Time.now}')").where("ms.data_servico < DATE_SUB(NOW(), INTERVAL pocos.periodo_manutencao YEAR)").group("pocos.id").order("ms.data_servico DESC")

			@fotos_admin = Foto.where("DATE(created_at) = CURRENT_DATE()").limit(9)
			@cidades_admin = Cidade.joins(:pocos).group(:id)

			@clientes = Cliente.count
			if @session_user.is_admin?
				@vendedores = Casein::AdminUser.where(pos_venda: true).order(:login)
			else
				@vendedores = Casein::AdminUser.where(id: @session_user.id)
			end
			@pocos = Poco.count
			@instalacoes = Instalacao.count
			@manutencoes = Manutencao.count
			@vazoes_agua = VazaoAgua.count
			@aprofundamentos = Aprofundamento.count

			unless @session_user.is_admin?
				@cidades = Cidade.joins(:pocos).where(id: @session_user.usuario_cidades.map { |x| x.cidade_id }).group(:id)
				@pocos_manutencao = Poco.select("pocos.id, pocos.cliente_id, pocos.linha_endereco, pocos.apelido_endereco, data_servico, DATE_SUB(NOW(), INTERVAL 3 YEAR), pocos.periodo_manutencao").joins("LEFT JOIN manutencaos m ON m.poco_id = pocos.id LEFT JOIN manutencao_servicos ms ON ms.manutencao_id = m.id").joins(:instalacao).where("ms.data_servico < DATE_SUB(NOW(), INTERVAL pocos.periodo_manutencao YEAR)").where(cidade_id: @session_user.usuario_cidades.map { |x| x.cidade_id }).group("pocos.id").order("ms.data_servico DESC").all
			else
				@cidades = Cidade.joins(:pocos).group(:id)
			end

			@clientes_fisica = Pessoa.where(tipo: false).joins(:cliente).count
			@clientes_juridica = Pessoa.where(tipo: true).joins(:cliente).count

		end
	end
end