class Fornecedor < ActiveRecord::Base
  audited
  
  belongs_to :pessoa
  
  accepts_nested_attributes_for :pessoa, :reject_if => :all_blank, :allow_destroy => true

  #Escopos para filtros de busca
  scope :nome, -> nome { joins(:pessoa).where("nome LIKE '%#{nome}%'") }
end