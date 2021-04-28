class Coordenada < ActiveRecord::Base
  audited
  
  belongs_to :poco

end
