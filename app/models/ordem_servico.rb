class OrdemServico < ActiveRecord::Base
  audited

  enum status: {
   'Início' => 1,
   'Iniciado' => 2,
   'Em Andamento' => 3,
   'Finalização' => 4,
   'Finalizado' => 5
  }

  belongs_to :poco
  belongs_to :funcionario

  has_many :ordem_servico_produtos, class_name: 'OrdemServicoProduto', dependent: :destroy
  has_many :ordem_servico_servicos, class_name: 'OrdemServicoServico', dependent: :destroy

  accepts_nested_attributes_for :ordem_servico_produtos, :allow_destroy => true, reject_if: lambda { |n| n[:produto_id].blank? }
  accepts_nested_attributes_for :ordem_servico_servicos, :allow_destroy => true, reject_if: lambda { |n| n[:servico_id].blank? }


  validates :poco_id, :funcionario_id, presence: true
end
