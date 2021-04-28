class CreateRevestimentoPocosBitola < ActiveRecord::Migration
  def self.up
    create_table :revestimento_pocos_bitola do |t|
      t.integer :revestimento_poco_id
      t.integer :bitola_id

      t.timestamps
    end
  end

  def self.down
    drop_table :revestimento_pocos_bitola
  end
end
