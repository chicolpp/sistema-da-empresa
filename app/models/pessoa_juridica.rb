class PessoaJuridica < ActiveRecord::Base
  audited

  belongs_to :pessoa

  has_one :contato_juridica, dependent: :destroy


  validates :cnpj, presence: true
  validates :cnpj, uniqueness: true, allow_blank: true
  # validates :ie, uniqueness: true, if: Proc.new { |pj| pj.ie != "ISENTO" }, allow_blank: true
  validates :pessoa_id, uniqueness: true, allow_blank: true
end