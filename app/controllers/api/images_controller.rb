# Controller for managing images
require 'net/http'

module Api
  class ImagesController < ApplicationController
    before_action :authenticate_devise_api_token!, only: [:create]

    def index
      cache_key = 'images_index'
      if (cached = $redis.get(cache_key))
        render json: JSON.parse(cached)
        return
      end

      unsplash_images = fetch_images_from_unsplash || []
      merged = merge_images(db_images_formatted, unsplash_images)

      cache_and_render(cache_key, merged)
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

    def db_images_formatted
      Image.all.each_with_object([]) do |img, out|
        next unless img.src.present?

        unless url_exists?(img.src)
          Rails.logger.warn "Skipping image id=#{img.id} because src is unreachable: #{img.src}"
          next
        end

        out << {
          id: img.id,
          title: img.title || 'Untitled',
          src: img.src,
          description: img.description,
          category: img.category
        }
      end
    end

    # Perform a quick HEAD request to check whether a URL exists/returns success.
    # Returns true for 2xx responses, false otherwise. Uses a short open/read timeout.
    def url_exists?(raw_url)
      uri = URI.parse(raw_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == 'https')
      http.open_timeout = 2
      http.read_timeout = 2

      request = Net::HTTP::Head.new(uri.request_uri)
      response = http.request(request)
      response.is_a?(Net::HTTPSuccess)
    rescue StandardError => e
      Rails.logger.debug "URL check failed for #{raw_url}: #{e.message}"
      false
    end

    def merge_images(db_images, unsplash_images)
      merged = []
      seen_srcs = {}

      db_images.each do |i|
        merged << i
        seen_srcs[i[:src]] = true if i[:src]
      end

      unsplash_images.each do |u|
        next unless u[:src]
        next if seen_srcs[u[:src]]

        merged << u
        seen_srcs[u[:src]] = true
      end

      merged
    end

    def cache_and_render(cache_key, payload)
      $redis.set(cache_key, payload.to_json, ex: 1.hour.to_i)
      render json: payload
    end
  end
end
