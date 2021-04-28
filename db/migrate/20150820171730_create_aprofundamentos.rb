class CreateAprofundamentos < ActiveRecord::Migration
  def self.up
    create_table :aprofundamentos do |t|
      t.date     :data_aprofundamento
      t.date     :data_lancamento
      t.integer  :poco_id
      t.string   :profundidade_nova
      t.integer  :bitola_id
      t.integer  :maquina_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :aprofundamentos
  end
end