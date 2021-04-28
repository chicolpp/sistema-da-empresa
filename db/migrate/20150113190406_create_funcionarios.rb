class CreateFuncionarios < ActiveRecord::Migration
  def self.up
    create_table :funcionarios do |t|
      t.references :pessoa, null: false
      t.integer :cargo
      t.string :carteira_profissional
      t.date :data_admissao
      t.date :data_demissao
      t.text :curriculo
      
      t.timestamps
    end
  end

  def self.down
    drop_table :funcionarios
  end
end