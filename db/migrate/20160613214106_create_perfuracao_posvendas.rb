class CreatePerfuracaoPosvendas < ActiveRecord::Migration
  def self.up
    create_table :perfuracao_posvendas do |t|
      t.integer :cliente_id
      t.integer :admin_user_id
      t.integer :pergunta1
      t.string :pergunta1_outros
      t.integer :pergunta2
      t.integer :pergunta3
      t.string :pergunta3_email
      t.integer :pergunta4
      t.string :pergunta4_motivo
      t.integer :pergunta5
      t.string :pergunta5_motivo
      t.integer :pergunta6
      t.integer :pergunta7
      t.integer :pergunta8
      t.string :pergunta8_motivo
      t.string :pergunta8_cliente
      t.string :pergunta9
      
      t.timestamps
    end
  end

  def self.down
    drop_table :perfuracao_posvendas
  end
end