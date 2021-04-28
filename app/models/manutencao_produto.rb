class ManutencaoProduto < ActiveRecord::Base
  audited
  
  belongs_to :produto
  belongs_to :manutencao

  validates :produto_id, :quantidade, presence: true
  validates :observacao, length: { maximum: 250 }
  validates :quantidade, length: { maximum: 10 }
end