class PessoaContato < ActiveRecord::Base
  audited
  
  belongs_to :pessoa
end