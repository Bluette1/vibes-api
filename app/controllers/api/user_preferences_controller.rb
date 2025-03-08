# app/controllers/api/user_preferences_controller.rb
module Api
  class UserPreferencesController < ApplicationController
    before_action :authenticate_devise_api_token!

    # GET /api/user_preferences
    def index
      devise_api_token = current_devise_api_token

      preference = devise_api_token.resource_owner.user_preference ||
                   devise_api_token.resource_owner.create_user_preference
      render json: { preferences: preference }, status: :ok
    end

    # POST /api/user_preferences
    def create
      devise_api_token = current_devise_api_token

      preference = devise_api_token.resource_owner.user_preference

      if preference.nil?
        preference = devise_api_token.resource_owner.create_user_preference(preference_params)
        status = :created
      else
        status = preference.update(preference_params) ? :ok : :unprocessable_entity
      end

      if status == :unprocessable_entity
        render(json: { errors: preference.errors }, status:)
      else
        render json: { preferences: preference }, status:
      end
    end

    private

    def preference_params
      params.require(:preferences).permit(:volume, :selected_track, :image_transition_interval)
    end
  end
end
