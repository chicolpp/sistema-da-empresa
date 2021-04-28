class Bomba < ActiveRecord::Base
  audited
  
  # belongs_to :bombeador
  belongs_to :energia
  belongs_to :estagio
  # belongs_to :hp
  belongs_to :modelo_bomba
  belongs_to :motor
  belongs_to :instalacao

  # validates :observacao, presence: true
  validates :observacao, length: { maximum: 250 }

  validates :modelo_bomba_id, :estagio_id, :motor_id, :energia_id, presence: true
end