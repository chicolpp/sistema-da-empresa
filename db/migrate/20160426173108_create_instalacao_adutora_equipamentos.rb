class CreateInstalacaoAdutoraEquipamentos < ActiveRecord::Migration
  def change
    create_table :instalacao_adutora_equipamentos do |t|
    	t.integer :instalacao_id
      t.integer :produto_id
      t.integer :quantidade
      t.string :observacao
      
      t.timestamps
    end
  end
end
