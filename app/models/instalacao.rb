class Instalacao < ActiveRecord::Base
  audited
  
  belongs_to :poco
  belongs_to :aprofundamento
  # has_one :instalacao, dependent: :destroy
  has_one :bomba, dependent: :destroy
  has_many :arquivos, dependent: :destroy, as: :owner
  has_many :instalacao_funcionarios, dependent: :destroy
  has_many :instalacao_poco_equipamentos, dependent: :destroy
  has_many :instalacao_adutora_equipamentos, dependent: :destroy
  has_many :instalacao_distribuicao_equipamentos, dependent: :destroy

  accepts_nested_attributes_for :bomba, :reject_if => :valida_instalacao, :allow_destroy => true
  accepts_nested_attributes_for :arquivos, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :instalacao_funcionarios, :reject_if => :valida_instalacao, :allow_destroy => true
  accepts_nested_attributes_for :instalacao_poco_equipamentos, :reject_if => :valida_instalacao, :allow_destroy => true
  accepts_nested_attributes_for :instalacao_adutora_equipamentos, :reject_if => :valida_instalacao, :allow_destroy => true
  accepts_nested_attributes_for :instalacao_distribuicao_equipamentos, :reject_if => :valida_instalacao, :allow_destroy => true

  #Escopos para filtros de busca
  scope :acesso, -> acesso { where(acesso: acesso) }
  scope :guincho, -> guincho { where(guincho: guincho) }
  scope :funcionario_id, -> funcionario_id { joins(:instalacao_funcionarios).where(instalacao_funcionarios: { funcionario_id: funcionario_id }) }
  scope :energia_id, -> energia_id { joins(bomba: :energia).where(bombas: { energia_id: energia_id }) }
  scope :profundidade, ->(profundidade_inicial, profundidade_final) { where(profundidade_bomba: profundidade_inicial..profundidade_final) if (profundidade_inicial == nil && profundidade_final == nil) }
  scope :vazao, ->(vazao_inicial, vazao_final) { where(vazao_bomba: vazao_inicial..vazao_final) if (vazao_inicial == nil && vazao_final == nil)}
  scope :cliente_id, -> cliente_id { where("pocos.cliente_id = ? OR aprofundamentos.poco_id IN (SELECT id FROM pocos WHERE cliente_id = ?)", cliente_id, cliente_id).joins("LEFT JOIN pocos ON pocos.id = instalacoes.poco_id LEFT JOIN aprofundamentos ON aprofundamentos.id = instalacoes.aprofundamento_id") }

  validates :poco_id, presence: true
  validates :possui_instalacao, presence: true, :if => Proc.new { |a| a[:possui_instalacao].to_s == "" }
  validates :guincho, presence: true, :if => Proc.new { |a| a[:guincho].to_s == "" && a[:possui_instalacao].to_s == "true"}
  validates :acesso, :profundidade_bomba, :vazao_bomba, presence: true, :if => Proc.new { |a| a[:possui_instalacao].to_s == "true" }

  after_commit :schedule_maintenance!, on: :create

  private

  def valida_instalacao
    if self.possui_instalacao
      return false
    else
      return true
    end
  end

  def schedule_maintenance!
    return if poco.lock_schedule_maintenance
    poco.update_schedule_maintenance_at!
  end
end