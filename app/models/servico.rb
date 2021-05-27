class Servico < ActiveRecord::Base
  audited
  
  has_many :manutencao_servicos
   
  validates :descricao, presence: true
  validates :descricao, length: { maximum: 250 }

  after_save :sync_service!

  private

  def sync_service!
    url = URI("#{ENV['CRM_SYNC_HOST']}/sync/services")

    http = Net::HTTP.new(url.host, url.port);
    request = Net::HTTP::Post.new(url)
    request["Auth-Token"] = ENV['CRM_SYNC_TOKEN']
    request["Content-Type"] = "application/json"
    request.body = {data: {
      name: descricao,
      sys_id: id
    }}.to_json

    begin http.request(request) rescue nil end
  end
end