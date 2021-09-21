class Api::V1::ImagesController < ApplicationController
    # skip_before_action :authorized, only: [:index]
    def index
        images = Api.fetch_images
        render json: images
    end
end
