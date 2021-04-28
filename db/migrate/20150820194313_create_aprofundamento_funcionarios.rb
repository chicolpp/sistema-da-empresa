class CreateAprofundamentoFuncionarios < ActiveRecord::Migration
  def self.up
    create_table :aprofundamento_funcionarios do |t|
      t.integer :aprofundamento_id
      t.integer :funcionario_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :aprofundamento_funcionarios
  end
end