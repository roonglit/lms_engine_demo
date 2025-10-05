module Lms
  class CurriculumItemsController < ApplicationController
    before_action :set_course
    before_action :set_curriculum_item

    # GET /courses/:course_id/curriculum_items/:id
    def show
      # The view will render based on whether item has video or other content
    end

    private

    def set_course
      @course = Course.find(params[:course_id])
    end

    def set_curriculum_item
      @curriculum_item = CurriculumItem.find(params[:id])
    end
  end
end
