module Api
	module V1
    class AuthenticationController < ApplicationController
      skip_before_action :authenticate_request
      
      def authenticate
        command = AuthenticateUser.call(params[:email], params[:password])
      
        if command.success?
          render json: { auth_token: command.result }
        else
          render json: { error: command.errors }, status: :unauthorized
        end
      end

      def auth_token
        command = CheckApiAuth.call(params[:token])
        render json: { user: command.result }, status: :ok
      end

    end
  end
end