class CreateManutencaoFuncionarios < ActiveRecord::Migration
  def self.up
    create_table :manutencao_funcionarios do |t|
      t.integer :manutencao_id
      t.integer :funcionario_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :manutencao_funcionarios
  end
end