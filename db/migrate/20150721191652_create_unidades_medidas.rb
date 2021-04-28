class CreateUnidadesMedidas < ActiveRecord::Migration
  def self.up
    create_table :unidades_medidas do |t|
      t.string :descricao
      
      t.timestamps
    end
  end

  def self.down
    drop_table :unidades_medidas
  end
end