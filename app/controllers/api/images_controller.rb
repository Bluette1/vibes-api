# Controller for managing images
require 'net/http'

module Api
  class ImagesController < ApplicationController
    before_action :authenticate_devise_api_token!, only: [:create]

    def index
      cache_key = 'images_index'
      cached_response = $redis.get(cache_key)

      if cached_response
        render json: JSON.parse(cached_response)
      else
        # Fetch images from Unsplash API
        unsplash_images = fetch_images_from_unsplash
        if unsplash_images.present?
          images = unsplash_images
        else
          # Fallback to default images from the database
          Rails.logger.debug 'Rendering Fallback'
          images = Image.all
        end
        $redis.set(cache_key, images.to_json, ex: 1.hour.to_i)
        render json: images
      end
    end

    def create
      devise_api_token = current_devise_api_token

      if devise_api_token
        render json: { message: "You are logged in as #{devise_api_token.resource_owner.email}" }, status: :ok
      else
        render json: { message: 'You are not logged in' }, status: :unauthorized
      end
    end

    private

    def fetch_images_from_unsplash
      url = URI("https://api.unsplash.com/search/photos?query=nature&client_id=#{ENV['UNSPLASH_ACCESS_KEY']}")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(url)

      response = http.request(request)
      json_data = JSON.parse(response.body)

      # Exclude images whose alt_description contains the words "computer" or "laptop" (case-insensitive)
      forbidden = %w[computer laptop]
      (json_data['results'] || []).each_with_object([]) do |image_data, out|
        alt = image_data['alt_description'].to_s.downcase
        next if forbidden.any? { |w| alt.include?(w) }

        out << {
          title: image_data['description'] || 'Untitled',
          src: image_data['urls']['small'],
          description: image_data['alt_description']
        }
      end
    rescue StandardError => e
      Rails.logger.error "Unsplash API Error: #{e.message}"
      nil
    end
  end
end
