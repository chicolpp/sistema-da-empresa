class VazaoAgua < ActiveRecord::Base
  audited
  
  belongs_to :poco
  belongs_to :aprofundamento
  has_many :vazao_agua_funcionarios, dependent: :destroy
  has_many :arquivos, dependent: :destroy, as: :owner

  accepts_nested_attributes_for :vazao_agua_funcionarios, :reject_if => :valida_vazao, :allow_destroy => true
  accepts_nested_attributes_for :arquivos, :reject_if => :all_blank, :allow_destroy => true

  #Escopos para filtros de busca
  scope :cliente_id, -> cliente_id { joins("LEFT JOIN pocos po ON po.id = vazoes_agua.poco_id LEFT JOIN aprofundamentos ON aprofundamentos.id = vazoes_agua.aprofundamento_id LEFT JOIN pocos poa ON poa.id = aprofundamentos.poco_id").where("(po.id IS NOT NULL OR poa.id IS NOT NULL) AND (po.cliente_id = '#{cliente_id}' OR poa.cliente_id = '#{cliente_id}')")}

  validates :poco_id, presence: true
  validates :vazao_teste, :vazao_dinamico, :nivel_estatico, :profundidade_bomba, presence: true, :if => Proc.new { |a| a[:possui_vazao] }

  private

  def valida_vazao
    if self.possui_vazao
      return false
    else
      return true
    end
  end
end