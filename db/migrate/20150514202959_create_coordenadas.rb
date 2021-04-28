class CreateCoordenadas < ActiveRecord::Migration
  def self.up
    create_table :coordenadas do |t|
      t.integer :ponto_a_latitude
      t.integer :ponto_a_longitude
      t.integer :ponto_b_latitude
      t.integer :ponto_b_longitude
      t.integer :ponto_c_latitude
      t.integer :ponto_c_longitude
      t.integer :ponto_d_latitude
      t.integer :ponto_d_longitude
      t.integer :ponto_e_latitude
      t.integer :ponto_e_longitude
      t.integer :poco_id

      t.timestamps
    end
  end

  def self.down
    drop_table :coordenadas
  end
end
