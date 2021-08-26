class Servico < ActiveRecord::Base
  audited
  
  attr_accessor :auto_sync

  has_many :manutencao_servicos
   
  validates :descricao, presence: true
  validates :descricao, length: { maximum: 250 }

  before_save :set_uuid!
  after_save :sync_service!, if: :auto_sync

  scope :visible_on_app, -> { where(exibe_app: true) }

  def auto_sync
    @auto_sync = true if @auto_sync.nil?
    @auto_sync
  end

private

  def set_uuid!
    self.uuid ||= SecureRandom.uuid
  end

  def sync_service!
    url = URI("#{ENV['CRM_SYNC_HOST']}/sync/services")

    http = Net::HTTP.new(url.host, url.port);
    request = Net::HTTP::Post.new(url)
    request["Auth-Token"] = ENV['CRM_SYNC_TOKEN']
    request["Content-Type"] = "application/json"
    request.body = {data: {
      name: descricao,
      uuid: uuid
    }}.to_json

    http.use_ssl = url.port == 443

    begin http.request(request) rescue nil end
  end
end