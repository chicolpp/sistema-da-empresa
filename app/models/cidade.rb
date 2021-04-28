class Cidade < ActiveRecord::Base
  audited
  
	belongs_to :estado
	has_many :pocos
	has_many :pessoa_endereco
	has_many :usuario_cidades

	def get_nome_completo
		return self.nome + " - " + self.estado.sigla
	end
end
