module Lms
  module Admin
    class VideosController < BaseController
      before_action :set_video, only: %i[ show edit update destroy ]

      # GET /admin/videos
      def index
        @videos = Video.all
      end

      # GET /admin/videos/1
      def show
      end

      # GET /admin/videos/new
      def new
        @video = Video.new(content: Content.new)
      end

      # GET /admin/videos/1/edit
      def edit
      end

      # POST /admin/videos
      def create 
        @video = Video.new(video_params)

        if @video.save
          redirect_to @video, notice: "Course was successfully created."
        else
          Rails.logger.debug "Course errors: #{@video.errors.full_messages}"
          render :new, status: :unprocessable_content
        end
      end

      # PATCH/PUT /admin/videos/1
      def update
        Rails.logger.debug "Raw params: #{params.inspect}"
        Rails.logger.debug "Course params: #{video_params.inspect}"
        
        if @video.update(video_params)
          redirect_to @video, notice: "Course was successfully updated.", status: :see_other
        else
          Rails.logger.debug "Course errors: #{@video.errors.full_messages}"
          render :edit, status: :unprocessable_content
        end
      end

      # DELETE /admin/videos/1
      def destroy
        @video.destroy!
        redirect_to videos_path, notice: "Course was successfully destroyed.", status: :see_other
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_video
          @video = Video.find(params.expect(:id))
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
end
