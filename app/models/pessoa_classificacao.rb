class PessoaClassificacao < ActiveRecord::Base
  audited
  
  belongs_to :pessoa
end