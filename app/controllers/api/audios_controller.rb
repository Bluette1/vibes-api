module Api
  class MeditationController < ApplicationController
    def index
      # Fetch background music or guided sessions based on audio type
      audios = Audio.by_audio_type(params[:audio_type])

      render json: audios
    end
  end
end
