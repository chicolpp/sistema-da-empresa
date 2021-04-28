class RevestimentoPocoBitola < ActiveRecord::Base
  audited
  
  belongs_to :revestimento_poco
  belongs_to :bitola
end
