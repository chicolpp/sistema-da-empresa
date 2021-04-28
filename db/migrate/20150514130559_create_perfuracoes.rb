class CreatePerfuracoes < ActiveRecord::Migration
  def self.up
    create_table :perfuracoes do |t|
      t.integer :poco_id
      t.date :data_perfuracao
      t.string :profundidade
      t.integer :maquina_id
      t.integer :bitola_id

      t.timestamps
    end
  end

  def self.down
    drop_table :perfuracoes
  end
end
