class PopulatePeriodoManutencao < ActiveRecord::Migration
  def change
    Instalacao.all.each do |instalacao|
      if instalacao.poco
        instalacao.poco.update(periodo_manutencao: instalacao.periodo_manutencao)
      end
    end
  end
end
