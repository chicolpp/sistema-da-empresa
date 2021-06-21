class Poco < ActiveRecord::Base
  audited

  attr_accessor :possoidados

  belongs_to :cliente
  belongs_to :cidade
  has_one :perfuracao, dependent: :destroy
  has_one :coordenada, dependent: :destroy
  has_one :vazao_agua, dependent: :destroy
  has_one :instalacao, dependent: :destroy
  has_many :revestimento_pocos, dependent: :destroy
  has_many :entradas_agua, dependent: :destroy
  has_many :aprofundamentos
  has_many :arquivos, dependent: :destroy, as: :owner
  has_many :manutencao_contatos, dependent: :destroy
  has_many :manutencaos, dependent: :destroy
  has_many :fotos, dependent: :destroy
  has_many :ordem_servicos

  accepts_nested_attributes_for :perfuracao, reject_if: :valida_perfuracao_leao, :allow_destroy => true
  accepts_nested_attributes_for :coordenada, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :revestimento_pocos, reject_if: :valida_perfuracao_leao, :allow_destroy => true
  accepts_nested_attributes_for :entradas_agua, reject_if: :valida_produtivo, :allow_destroy => true
  accepts_nested_attributes_for :arquivos, :reject_if => :all_blank, :allow_destroy => true

  validates :perfuracao_leao, presence: true, :if => Proc.new { |a| a[:perfuracao_leao].to_s == "" }
  validates :poco_produtivo, presence: true, :if => Proc.new { |a| a[:poco_produtivo].to_s == "" }
  validates :cliente_id, :apelido_endereco, :linha_endereco, :cidade_id, presence: true

  #Escopos para filtros de busca
  scope :cliente_id, -> cliente_id { where("cliente_id = '#{cliente_id}'") }
  scope :perfuracao_leao, -> perfuracao_leao { where("perfuracao_leao = #{perfuracao_leao.to_i}") }
  scope :poco_produtivo, -> poco_produtivo { where("poco_produtivo = #{poco_produtivo.to_i}") }
  scope :estado_id, -> estado_id { joins("INNER JOIN cidades AS c ON c.id = cidade_id JOIN estados ON c.estado_id = estados.id").where("estados.id = #{estado_id}")}
  scope :cidade_id, -> cidade_id { where("pocos.cidade_id = #{cidade_id}") }
  scope :linha_endereco, -> linha_endereco { where("linha_endereco LIKE '%#{linha_endereco}%'") }
  scope :apelido_endereco, -> apelido_endereco { where("apelido_endereco LIKE '%#{apelido_endereco}%'") }
  scope :profundidade_de, -> profundidade_de { joins("INNER JOIN perfuracoes pp ON pocos.id = pp.poco_id").where("pp.profundidade >= #{profundidade_de}")}
  scope :profundidade_ate, -> profundidade_ate { joins("INNER JOIN perfuracoes pp ON pocos.id = pp.poco_id").where("pp.profundidade <= #{profundidade_ate}")}
  scope :revestimento_id, -> revestimento_id { joins("INNER JOIN revestimento_pocos ON pocos.id = revestimento_pocos.poco_id").where("revestimento_pocos.tipo_revestimento_id = #{revestimento_id}")}
  scope :funcionario_id, -> funcionario_id { joins("INNER JOIN perfuracoes pf ON pocos.id = pf.poco_id JOIN perfuracao_funcionarios ON pf.id = perfuracao_funcionarios.perfuracao_id").where("perfuracao_funcionarios.funcionario_id = #{funcionario_id}")}
  scope :maquina_id, -> maquina_id { joins("INNER JOIN perfuracoes pm ON pocos.id = pm.poco_id").where("pm.maquina_id = #{maquina_id}")}
  scope :data, ->(data_inicial, data_final) { joins("INNER JOIN perfuracoes pdi ON pocos.id = pdi.poco_id").where("pdi.data_perfuracao_inicio BETWEEN '#{data_inicial.to_date}' AND '#{data_final.to_date}'") if (!data_inicial.blank? && !data_final.blank?)}
  scope :data_manutencao, ->(data_inicial, data_final) { joins("INNER JOIN manutencaos dmm ON pocos.id = dmm.poco_id INNER JOIN manutencao_servicos ON dmm.id = manutencao_servicos.manutencao_id").where("manutencao_servicos.data_servico BETWEEN '#{data_inicial.to_date}' AND '#{data_final.to_date}'") if (!data_inicial.blank? && !data_final.blank?)}
  scope :numero_processo, -> numero_processo { where("pocos.numero_processo LIKE '#{numero_processo}%'") }
  scope :tipo_manutencao, -> tipo_manutencao { joins("INNER JOIN manutencaos ON pocos.id = manutencaos.poco_id").where("manutencaos.servico_id = #{tipo_manutencao}") }

  before_save :handle_change_schedule_maintenance_at!, if: :periodo_manutencao_changed?

  def nome_poco
    if !cliente.blank?
      if !cliente.pessoa.blank?
        "#{cliente.pessoa.nome}"
      else
        "-"
      end
    else
      "-"
    end
  end

  def nome_intuitivo
    if !cliente.blank?
      if !cliente.pessoa.blank?
        "#{cliente.pessoa.nome} - #{linha_endereco} - #{apelido_endereco}"
      else
        "-"
      end
    else
      "-"
    end
  end

  def update_schedule_maintenance_at!
    set_schedule_maintenance_at
    self.lock_schedule_maintenance = false
    save!
  end


  private

  def valida_perfuracao_leao
    if self.perfuracao_leao
      return false
    else
      return !possoidados
    end
  end

  def valida_produtivo
    if self.poco_produtivo && self.perfuracao_leao
      return false
    else
      return true
    end
  end

  def handle_change_schedule_maintenance_at!
    return if lock_schedule_maintenance?
    set_schedule_maintenance_at
  end

  def set_schedule_maintenance_at
    return unless periodo_manutencao.to_i > 0

    ref_date = instalacao.try(:data_instalacao_inicio)
    ref_date ||= perfuracao.try(:data_perfuracao_fim)

    if last_maintenance = ManutencaoServico.joins(:manutencao).where(manutencaos: {poco_id: id}).where("data_servico IS NOT NULL").order(:data_servico).last
      ref_date = last_maintenance.data_servico
    end

    if(ref_date)
      new_date = ref_date.since( periodo_manutencao.to_i.years )
      self.schedule_maintenance_at = new_date
    end
  end
end
