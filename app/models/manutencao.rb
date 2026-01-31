class Manutencao < ActiveRecord::Base
  audited

  belongs_to :poco
  belongs_to :servico
  belongs_to :ordem_servico

  has_many :arquivos, dependent: :destroy, as: :owner
  has_many :manutencao_servicos, dependent: :destroy
  has_many :manutencao_produtos, dependent: :destroy
  has_many :manutencao_checklists, dependent: :destroy

  accepts_nested_attributes_for :arquivos,              :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :manutencao_servicos,   :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :manutencao_produtos,   :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :manutencao_checklists, :reject_if => :all_blank, :allow_destroy => true

  # scope :descricao_servico, -> descricao_servico { where("descricao_servico ILIKE ?", "%#{descricao_servico}%") }
  scope :codigo, -> codigo { where(poco_id: codigo) }

  validates :poco_id, :servico_id, :pessoa_contato, presence: true
end