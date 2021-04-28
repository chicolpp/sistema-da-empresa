class CreateManutencaoServicos < ActiveRecord::Migration
  def self.up
    create_table :manutencao_servicos do |t|
      t.integer :manutencao_id
      t.integer :servico_id

      t.timestamps
    end
  end

  def self.down
    drop_table :manutencao_servicos
  end
end