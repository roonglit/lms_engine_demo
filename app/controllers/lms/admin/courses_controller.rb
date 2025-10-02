module Lms
  module Admin
    class CoursesController < BaseController
      before_action :set_course, only: %i[ show edit update destroy ]

      # GET /admin/courses
      def index
        @courses = Course.all
      end

      # GET /admin/courses/1
      def show
      end

      # GET /admin/courses/new
      def new
        @course = Course.new(content: Content.new)
      end

      # GET /admin/courses/1/edit
      def edit
      end

      # POST /admin/courses
      def create 
        @course = Course.new(course_params)

        if @course.save
          redirect_to @course, notice: "Course was successfully created."
        else
          Rails.logger.debug "Course errors: #{@course.errors.full_messages}"
          render :new, status: :unprocessable_content
        end
      end

      # PATCH/PUT /admin/courses/1
      def update
        Rails.logger.debug "Raw params: #{params.inspect}"
        Rails.logger.debug "Course params: #{course_params.inspect}"
        
        if @course.update(course_params)
          redirect_to @course, notice: "Course was successfully updated.", status: :see_other
        else
          Rails.logger.debug "Course errors: #{@course.errors.full_messages}"
          render :edit, status: :unprocessable_content
        end
      end

      # DELETE /admin/courses/1
      def destroy
        @course.destroy!
        redirect_to courses_path, notice: "Course was successfully destroyed.", status: :see_other
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_course
          @course = Course.find(params.expect(:id))
        end

        # Only allow a list of trusted parameters through.
        def course_params
          params.expect(course: [ 
            :text_content, :cover,
            content_attributes: [:id, :title, :subtitle, :description, :cover, :_destroy],
            sections_attributes: [[
              :id, :name, :_destroy,
              curriculum_items_attributes: [[
                :id, :name, :_destroy, :video
              ]]
            ]]
          ])
        end
    end
  end
end
