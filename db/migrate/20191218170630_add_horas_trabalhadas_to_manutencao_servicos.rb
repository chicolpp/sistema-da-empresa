class AddHorasTrabalhadasToManutencaoServicos < ActiveRecord::Migration
  def change
    add_column :manutencao_servicos, :horas_trabalhadas, :integer
  end
end
