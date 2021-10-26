class OrdemServico < ActiveRecord::Base
  audited

  enum status: {
   'Início' => 1,
   'Iniciado' => 2,
   'Em Andamento' => 3,
   'Finalização' => 4,
   'Finalizado' => 5,
   'Concluído' => 6
  }

  belongs_to :poco
  belongs_to :funcionario

  has_one :manutencao

  has_many :ordem_servico_produtos, class_name: 'OrdemServicoProduto', dependent: :destroy
  has_many :ordem_servico_servicos, class_name: 'OrdemServicoServico', dependent: :destroy

  accepts_nested_attributes_for :ordem_servico_produtos, :allow_destroy => true, reject_if: lambda { |n| n[:produto_id].blank? }
  accepts_nested_attributes_for :ordem_servico_servicos, :allow_destroy => true, reject_if: lambda { |n| n[:servico_id].blank? }

  scope :sync_includes, -> {
    includes(ordem_servico_servicos: :servico)
    .includes(ordem_servico_produtos: :produto)
    .includes({poco: {cliente: :pessoa}})
    .includes({poco: :instalacao})
    .includes(:funcionario)
  }


  validates :poco_id, :funcionario_id, presence: true

  def status_code
    OrdemServico.statuses[status]
  end
end
