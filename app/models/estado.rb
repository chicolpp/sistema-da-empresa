class Estado < ActiveRecord::Base
  audited
  
	has_many :cidades
end