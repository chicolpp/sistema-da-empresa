class CreateOrdemServicosServico < ActiveRecord::Migration
  def change
    create_table :ordem_servico_servicos do |t|
      t.references :ordem_servico, index:true, foreign_key: {to_table: :ordem_servicos}
      t.references :servico, index:true, foreign_key: {to_table: :servicos}

      t.timestamps
    end
  end
end
