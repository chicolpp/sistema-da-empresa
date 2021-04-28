#encoding: utf-8
class Funcionario < ActiveRecord::Base
  audited

  after_create :apagar_cliente
  # after_update :handle_app_user

  belongs_to :pessoa
  belongs_to :cargo
  has_many :perfuracao_funcionarios
  has_many :vazao_agua_funcionarios
  has_many :instalacao_funcionarios
  has_many :aprofundamento_funcionarios
  has_many :manutencao_funcionarios
  has_many :ordem_servicos

  accepts_nested_attributes_for :pessoa, :reject_if => :all_blank, :allow_destroy => true

  #Escopos para filtros de busca
  scope :nome, -> nome { joins(:pessoa).where("nome LIKE '%#{nome}%'") }

  validate  :validacao_nome_unico_funcionario

  private

  def validacao_nome_unico_funcionario
    if !self.pessoa.nome.blank?
      errors.add(:nome, "já está em uso por um funcionário") if Funcionario.joins(:pessoa).where("pessoas.nome = '#{self.pessoa.nome}'").where.not(id: self.id).exists?
    end
  end

  #por causa de gambiarras feitas no projeto temos que apagar o cliente gerado de forma errada =///
  def apagar_cliente
    cliente = Cliente.find_by_pessoa_id(self.pessoa.id)
    cliente.destroy
  end

  def self.create_app_user(funcionario, email, active, pass)
    userApp = UserApp.create!(funcionarios_id: funcionario, email: email , password: pass , password_confirmation: pass, active: active)
    userApp.save
  end

  def self.handle_app_user(funcionario, email, active, pass)
    if UserApp.where(funcionarios_id: funcionario).present?
      @record = UserApp.find_by(funcionarios_id: funcionario)
      @record.email = email
      @record.active = active
      @record.save
    else
      newUser = UserApp.create!(funcionarios_id: funcionario, email: email, password: pass, password_confirmation: pass, active: active)
      newUser.save
    end
  end

end