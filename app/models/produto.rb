class Produto < ActiveRecord::Base
  audited

  attr_accessor :auto_sync

  belongs_to :unidade_medida
  has_many :instalacao_poco_equipamentos
  has_many :instalacao_adutora_equipamentos
  has_many :instalacao_distribuicao_equipamentos
  has_many :manutencao_produtos

  # validates :descricao, uniqueness: true
  validates :descricao, length: { maximum: 250 }
  validates :descricao, :unidade_medida_id, presence: true

  before_save :set_uuid!
  after_save :sync_product!, if: :auto_sync

  def auto_sync
    @auto_sync = true if @auto_sync.nil?
    @auto_sync
  end

private

  def set_uuid!
    self.uuid ||= SecureRandom.uuid
  end

  def sync_product!
    url = URI("#{ENV['CRM_SYNC_HOST']}/sync/products")

    http = Net::HTTP.new(url.host, url.port);
    request = Net::HTTP::Post.new(url)
    request["Auth-Token"] = ENV['CRM_SYNC_TOKEN']
    request["Content-Type"] = "application/json"
    request.body = {data: {
      name: descricao,
      measurement_unit: (unidade_medida ? unidade_medida.descricao : nil),
      available_for_branch: exibir_app?,
      uuid: uuid
    }}.to_json

    begin http.request(request) rescue nil end
  end
end