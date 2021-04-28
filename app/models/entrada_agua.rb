class EntradaAgua < ActiveRecord::Base
  audited
  
  belongs_to :poco
  belongs_to :aprofundamento

  validates :metragem, :vazao_aproximada, presence: true
end