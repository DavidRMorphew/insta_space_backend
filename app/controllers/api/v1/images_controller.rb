class Api::V1::ImagesController < ApplicationController
    def index
        images = Api.fetch_images
        render json: images
    end
end