class CreateInstalacaoFuncionarios < ActiveRecord::Migration
  def self.up
    create_table :instalacao_funcionarios do |t|
      t.integer :instalacao_id
      t.integer :funcionario_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :instalacao_funcionarios
  end
end