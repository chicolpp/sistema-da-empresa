class OrdemServicoServico < ActiveRecord::Base
  def self.table_name
    'ordem_servico_servicos'
  end

  belongs_to :ordem_servico
  belongs_to :servico


end
