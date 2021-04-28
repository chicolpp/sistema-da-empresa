class Alerta < ActiveRecord::Base
  audited

  has_many :arquivos, dependent: :destroy, as: :owner
  accepts_nested_attributes_for :arquivos, :reject_if => :all_blank, :allow_destroy => true

  validates :titulo, :descricao, :exibir_ate, presence: true
end