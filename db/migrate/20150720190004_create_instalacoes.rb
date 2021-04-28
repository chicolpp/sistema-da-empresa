class CreateInstalacoes < ActiveRecord::Migration
  def self.up
    create_table :instalacoes do |t|
      t.integer :poco_id
      t.integer :acesso
      t.boolean :guincho
      t.integer :profundidade_bomba
      t.integer :vazao_bomba
      t.integer :nivel_dinamico
      t.integer :perca_carga
      t.integer :altura_nanometrica
      t.integer :desnivel
      t.integer :nivel_estatico
      t.integer :distancia_poco_caixa
      t.integer :bomba_id
      t.integer :aprofundamento_id
      t.boolean :possui_instalacao
      
      t.timestamps
    end
  end

  def self.down
    drop_table :instalacoes
  end
end