class CreateRevestimentoPocos < ActiveRecord::Migration
  def self.up
    create_table :revestimento_pocos do |t|
      t.string :quantidade
      t.integer :tipo_revestimento_id
      t.integer :poco_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :revestimento_pocos
  end
end