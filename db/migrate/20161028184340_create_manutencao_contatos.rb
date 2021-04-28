class CreateManutencaoContatos < ActiveRecord::Migration
  def self.up
    create_table :manutencao_contatos do |t|
      t.integer :poco_id
      t.integer :manutencao_servico
      t.text :observacao
      t.date :nova_data
      
      t.timestamps
    end
  end

  def self.down
    drop_table :manutencao_contatos
  end
end