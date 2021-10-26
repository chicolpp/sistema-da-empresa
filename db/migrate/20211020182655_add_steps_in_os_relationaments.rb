class AddStepsInOsRelationaments < ActiveRecord::Migration
  def change
    add_column :arquivos,              :step, :integer
    add_column :manutencao_servicos,   :step, :integer
    add_column :manutencao_checklists, :step, :integer
  end
end
