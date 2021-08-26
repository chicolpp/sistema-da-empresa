class OrdemServicoProduto < ActiveRecord::Base
  def self.table_name
    'ordem_servico_produtos'
  end

  belongs_to :ordem_servico
  belongs_to :produto
end
