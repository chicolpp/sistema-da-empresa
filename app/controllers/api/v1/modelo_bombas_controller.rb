require "time"

module Api
  module V1
    class ModeloBombasController < APIController
      def index
        @modelo_bombas = ModeloBomba.all
        render json:@modelo_bombas, status: :ok
      end
    end
  end
end