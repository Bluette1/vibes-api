module Api
  class AudiosController < ApplicationController
    def index
      cache_key = 'audios_index'
      cached_response = $redis.get(cache_key)

      if cached_response
        render json: JSON.parse(cached_response)
      else
        # Fetch background music or guided sessions based on audio type
        audios = if params[:audio_type]
                   Audio.by_audio_type(params[:audio_type])
                 else

                   Audio.all

                 end
        $redis.set(cache_key, audios.to_json, ex: 1.hour.to_i)
        render json: audios
      end
    end
  end
end
