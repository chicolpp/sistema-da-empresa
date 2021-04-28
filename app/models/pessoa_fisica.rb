class PessoaFisica < ActiveRecord::Base
  audited
  
  belongs_to :pessoa

  validates :cpf, :rg, :data_nascimento, presence: true
  validates :cpf, uniqueness: true, allow_blank: true
  validates :pessoa_id, uniqueness: true, allow_blank: true
end