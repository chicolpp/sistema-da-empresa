class CreateBombas < ActiveRecord::Migration
  def self.up
    create_table :bombas do |t|
      t.text :descricao
      t.integer :modelo_bomba_id
      t.integer :estagio_id
      t.integer :hp_id
      t.integer :energia_id
      t.integer :motor_id
      t.integer :bombeador_id

      t.timestamps
    end
  end

  def self.down
    drop_table :bombas
  end
end
