class AddUseAppToFuncionarios < ActiveRecord::Migration
  def change
    add_column :funcionarios, :use_app, :boolean
  end
end
