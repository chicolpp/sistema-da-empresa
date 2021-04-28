class CreateEntradasAgua < ActiveRecord::Migration
  def self.up
    create_table :entradas_agua do |t|
      t.string :metragem
      t.string :vazao_aproximada
      t.integer :poco_id
      t.integer :aprofundamento_id

      t.timestamps
    end
  end

  def self.down
    drop_table :entradas_agua
  end
end
