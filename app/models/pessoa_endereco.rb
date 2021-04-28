class PessoaEndereco < ActiveRecord::Base
  audited
  
  belongs_to :pessoa
  belongs_to :cidade

  validates :cep, :endereco, :numero, :bairro, :cidade_id, presence: true
end