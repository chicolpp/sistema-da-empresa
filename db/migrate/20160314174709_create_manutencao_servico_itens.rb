class CreateManutencaoServicoItens < ActiveRecord::Migration
  def self.up
    create_table :manutencao_servico_itens do |t|
      t.integer :manutencao_servico_id
      t.integer :produto_id
      t.string :quantidade
      
      t.timestamps
    end
  end

  def self.down
    drop_table :manutencao_servico_itens
  end
end