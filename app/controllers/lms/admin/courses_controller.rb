module Lms
  module Admin
    class CoursesController < ApplicationController
      before_action :set_course, only: %i[ show edit update destroy ]

      # GET /admin/courses
      def index
        @admin_courses = Course.all
      end

      # GET /admin/courses/1
      def show
      end

      # GET /admin/courses/new
      def new
        @admin_course = Course.new
      end

      # GET /admin/courses/1/edit
      def edit
      end

      # POST /admin/courses
      def create
        @admin_course = Course.new(admin_course_params)

        if @admin_course.save
          redirect_to @admin_course, notice: "Course was successfully created."
        else
          render :new, status: :unprocessable_content
        end
      end

      # PATCH/PUT /admin/courses/1
      def update
        if @admin_course.update(admin_course_params)
          redirect_to @admin_course, notice: "Course was successfully updated.", status: :see_other
        else
          render :edit, status: :unprocessable_content
        end
      end

      # DELETE /admin/courses/1
      def destroy
        @admin_course.destroy!
        redirect_to admin_courses_path, notice: "Course was successfully destroyed.", status: :see_other
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_course
          @admin_course = Course.find(params.expect(:id))
        end

        # Only allow a list of trusted parameters through.
        def admin_course_params
          params.fetch(:admin_course, {})
        end
    end
  end
end
