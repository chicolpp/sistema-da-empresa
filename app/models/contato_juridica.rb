class ContatoJuridica < ActiveRecord::Base
  audited 
  belongs_to :pessoa_juridica
end
