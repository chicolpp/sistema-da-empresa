class CreateClientes < ActiveRecord::Migration
  def self.up
    create_table :clientes do |t|
      t.references :pessoa, null: false
      t.date :data_inicio, null: false
      t.date :data_final, null: false

      t.timestamps
    end
  end

  def self.down
    drop_table :clientes
  end
end
