class CreateManutencaos < ActiveRecord::Migration
  def self.up
    create_table :manutencaos do |t|
      t.date :data_iniciada
      t.date :data_final
      t.integer :poco_id
      t.text :descricao_servico
      t.string :contato
      t.string :telefone
      t.string :email
      
      t.timestamps
    end
  end

  def self.down
    drop_table :manutencaos
  end
end