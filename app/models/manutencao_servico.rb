class ManutencaoServico < ActiveRecord::Base
  audited

  WELL_DATA_LABELS = {
    profunDoPoco:        'Profundidade',
    profunDaBomba:       'Profundidade da bomba',
    desnivel:            'Desnível',
    distPocoRes:         'Distância do poço até o reservatório',
    ltsRes:              'Capacidade do reservatório',
    qntCaboSub:          'Quantidade de cabos submersíveis',
    bitola3x:            'Quantidade de bitola 3x',
    bitolaDoPoco:        'Quantidade do poço',
    qntTubo:             'Quantidade de tubo',
    tipoTubo:            'Tipo do tubo',
    modeloBomba:         'Modelo da bomba',
    bombaVolts:          'Energia da bomba',
    produtosNaoListados: 'Produtos não listados',
  }
  
  belongs_to :manutencao
  has_many :manutencao_funcionarios, dependent: :destroy
  accepts_nested_attributes_for :manutencao_funcionarios, :reject_if => :all_blank, :allow_destroy => true
  has_many :manutencao_servico_itens, dependent: :destroy
  accepts_nested_attributes_for :manutencao_servico_itens, :reject_if => :all_blank, :allow_destroy => true

  validates :tipo, :data_servico, presence: true

  after_commit :update_schedule_maintenance!, on: :create
  after_destroy :update_schedule_maintenance!

  serialize :well_data,     Object
  serialize :service_items, Array # [{id: 1, name: 'Lala'}]

  def update_schedule_maintenance!
    return unless manutencao && manutencao.poco
    manutencao.poco.update_schedule_maintenance_at!
  end

  def self.label_for_well_data(key)
    ManutencaoServico::WELL_DATA_LABELS[key.to_sym]
  end
end