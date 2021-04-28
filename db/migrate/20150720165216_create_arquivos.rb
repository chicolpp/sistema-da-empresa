class CreateArquivos < ActiveRecord::Migration
  def self.up
    create_table :arquivos do |t|
      t.string :vazao_agua_id
      t.integer :instalacao_id
      t.attachment :upload
      
      t.timestamps
    end
  end

  def self.down
    drop_table :arquivos
  end
end