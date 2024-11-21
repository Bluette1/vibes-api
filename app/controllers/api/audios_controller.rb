module Api
  class AudiosController < ApplicationController
    def index
      # Fetch background music or guided sessions based on audio type
      audios = if params[:audio_type]
                 Audio.by_audio_type(params[:audio_type])
               else

                 Audio.all

               end

      render json: audios
    end
  end
end
