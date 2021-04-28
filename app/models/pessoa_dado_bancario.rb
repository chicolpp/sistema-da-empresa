class PessoaDadoBancario < ActiveRecord::Base
  audited
  
  belongs_to :pessoa
  
  validates :pessoa_id, uniqueness: true, allow_blank: true
end