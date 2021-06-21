class ManutencaoServico < ActiveRecord::Base
  audited
  
  belongs_to :manutencao
  has_many :manutencao_funcionarios, dependent: :destroy
  accepts_nested_attributes_for :manutencao_funcionarios, :reject_if => :all_blank, :allow_destroy => true
  has_many :manutencao_servico_itens, dependent: :destroy
  accepts_nested_attributes_for :manutencao_servico_itens, :reject_if => :all_blank, :allow_destroy => true

  validates :tipo, :data_servico, presence: true

  after_commit :update_schedule_maintenance!, on: :create
  after_destroy :update_schedule_maintenance!


  def update_schedule_maintenance!
    return unless manutencao && manutencao.poco
    manutencao.poco.update_schedule_maintenance_at!
  end
end