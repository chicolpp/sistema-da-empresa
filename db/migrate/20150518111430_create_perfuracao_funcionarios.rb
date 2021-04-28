class CreatePerfuracaoFuncionarios < ActiveRecord::Migration
  def self.up
    create_table :perfuracao_funcionarios do |t|
      t.integer :perfuracao_id
      t.integer :funcionario_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :perfuracao_funcionarios
  end
end