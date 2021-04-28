class CreateTipoRevestimentos < ActiveRecord::Migration
  def self.up
    create_table :tipo_revestimentos do |t|
      t.string :descricao
      
      t.timestamps
    end
  end

  def self.down
    drop_table :tipo_revestimentos
  end
end