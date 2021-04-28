class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= Casein::AdminUser.new
    if user.access_level == 0
      can :manage, :all
    elsif user.access_level == 10
      can :relatorio_detalhes, Poco
      can :filtro_relatorio, Poco
      can :index, Cliente
      can :show, Pessoa
      can :new, Pessoa
      can :create, Pessoa
      can :edit, Pessoa
      can :update, Pessoa
      can :index, Manutencao
      can :show, Manutencao
      can :new, Manutencao
      can :create, Manutencao
      can :new, Foto
      can :create, Foto
      can :index, Foto
      can :show, Foto
      can :show, Alerta
      can :show, Notification, :vendedor_id => user.id
      can :create, ManutencaoContato
      can :index, PerfuracaoPosvenda, :admin_user_id => user.id
      can :show, PerfuracaoPosvenda, :admin_user_id => user.id
      can :index, AssistenciaPosvenda, :admin_user_id => user.id
      can :show, AssistenciaPosvenda, :admin_user_id => user.id
    else
      can :create, Foto
    end
  end
end