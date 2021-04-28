class CreateOrcamentos < ActiveRecord::Migration
  def self.up
    create_table :orcamentos do |t|
      t.integer :cliente_id
      t.date :data_proposta
      t.integer :casein_admin_user_id
      t.string :validade_proposta
      t.string :prazo_inicio
      t.string :prazo_execucao
      t.string :condicao_pagamento
      t.string :descricao
      t.string :cidade_data
      
      t.timestamps
    end
  end

  def self.down
    drop_table :orcamentos
  end
end