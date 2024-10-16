# Controller for managing images
module Api
  class ImagesController < ApplicationController
    before_action :authenticate_devise_api_token!, only: [:create]

    require 'net/http'

    def index
      # Fetch images from Getty API
      getty_images = fetch_images_from_getty

      if getty_images.present?
        render json: getty_images
      else
        # Fallback to default images from the database
        Rails.logger.debug 'Rendering Fallback'
        default_images = Image.all
        render json: default_images
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

    def fetch_images_from_getty
      # Example API call (replace with actual API logic)
      url = URI('https://api.gettyimages.com/v3/search/images?phrase=nature')
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(url)
      request['Api-Key'] = ENV['GETTY_API_KEY'] # Ensure you have your API key

      response = http.request(request)
      json_data = JSON.parse(response.body)

      # Assuming the API returns an array of image data
      json_data['images'].map do |image_data|
        {
          title: image_data['title'],
          url: image_data['display_sizes'][0]['uri'],
          description: image_data['caption']
        }
      end
    rescue StandardError => e
      Rails.logger.error "Getty API Error: #{e.message}"
      nil
    end
  end
end
