class AuthenticateUser
  prepend SimpleCommand

  def initialize(email, password)
    @email = email
    @password = password
  end

  def call
    return unless user
    @Func = Funcionario.find(user.funcionarios_id)
    @Pessoa = Pessoa.find(@Func.pessoa_id)
    JsonWebToken.encode(user_id: user.id, user_name: @Pessoa.nome) if user
  end

  def decode
    JsonWebToken.decode()
  end

  private

  attr_accessor :email, :password

  def user
    user = UserApp.find_by_email(email)
    return user if user && user.authenticate(password)

    errors.add :user_authentication, 'invalid credentials'
    nil
  end
end