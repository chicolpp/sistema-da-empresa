class CreateVazoesAgua < ActiveRecord::Migration
  def self.up
    create_table :vazoes_agua do |t|
      t.string :vazao_teste
      t.string :vazao_dinamico
      t.string :nivel_estatico
      t.string :recuperacao
      t.integer :poco_id
      t.integer :aprofundamento_id

      t.timestamps
    end
  end

  def self.down
    drop_table :vazoes_agua
  end
end
