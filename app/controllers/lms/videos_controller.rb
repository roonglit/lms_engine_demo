module Lms
  class VideosController < ApplicationController
    before_action :set_video, only: %i[ show edit update destroy ]

    # GET /videos
    def index
      @videos = Video.all
    end

    # GET /videos/1
    def show
    end

    # GET /videos/new
    def new
      @video = Video.new(content: Content.new)
    end

    # GET /videos/1/edit
    def edit
    end

    # POST /videos
    def create
      @video = Video.new(video_params)

      if @video.save
        redirect_to @video, notice: "Video was successfully created."
      else
        render :new, status: :unprocessable_content
      end
    end

    # PATCH/PUT /videos/1
    def update
      if @video.update(video_params)
        redirect_to @video, notice: "Video was successfully updated.", status: :see_other
      else
        render :edit, status: :unprocessable_content
      end
    end

    # DELETE /videos/1
    def destroy
      @video.destroy!
      redirect_to videos_path, notice: "Video was successfully destroyed.", status: :see_other
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_video
        @video = Video.includes(:content).find(params.expect(:id))
      end

      # Only allow a list of trusted parameters through.
      def video_params
        params_with_user = params.expect(video: [
          :video,
          content_attributes: [:id, :title, :subtitle, :description, :cover, :user_id, :_destroy],
        ])
        params_with_user[:content_attributes][:user_id] = current_user.id
        params_with_user
      end
  end
end
