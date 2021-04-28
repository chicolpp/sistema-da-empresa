class CreateVazaoAguaFuncionarios < ActiveRecord::Migration
  def self.up
    create_table :vazao_agua_funcionarios do |t|
      t.integer :vazao_agua_id
      t.integer :funcionario_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :vazao_agua_funcionarios
  end
end