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


  validates :poco_id, :funcionario_id, presence: true
end
