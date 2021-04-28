class AddEmailToFuncionarios < ActiveRecord::Migration
  def change
    add_column :funcionarios, :email, :string
  end
end
