require "time"

module Api
  module V1
      class ProdutosController < APIController
          def index
              @produtos = Produto.all
              render json:@produtos, status: :ok
          end
      end
  end
end