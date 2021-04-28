class CreateAssistenciaPosvendas < ActiveRecord::Migration
  def self.up
    create_table :assistencia_posvendas do |t|
      t.integer :cliente_id
      t.integer :admin_user_id
      t.integer :pergunta1
      t.string :pergunta1_outros
      t.integer :pergunta2
      t.integer :pergunta3
      t.string :pergunta3_motivo
      t.integer :pergunta4
      t.string :pergunta4_motivo
      t.integer :pergunta5
      t.string :pergunta5_motivo
      t.integer :pergunta6
      t.string :pergunta6_motivo
      t.integer :pergunta7
      t.integer :pergunta8
      t.integer :pergunta9
      t.string :pergunta9_motivo
      t.string :pergunta10
      
      t.timestamps
    end
  end

  def self.down
    drop_table :assistencia_posvendas
  end
end