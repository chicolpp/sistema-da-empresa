module Api
    module V1
        class OrdemController < APIController
            def index
                @o = ManutencaoFuncionario.where(funcionario_id: @current_user.funcionarios_id)
                render json:@o, status: :ok
            end
        end
    end
end