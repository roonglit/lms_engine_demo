module Lms
  class EventsController < ApplicationController
    before_action :set_event, only: %i[ show edit update destroy ]

    # GET /events
    def index
      @events = Event.all
    end

    # GET /events/1
    def show
    end

    # GET /events/new
    def new
      @event = Event.new(content: Content.new)
    end

    # GET /events/1/edit
    def edit
    end

    # POST /events
    def create
      @event = Event.new(event_params)

      if @event.save
        redirect_to lms.root_path, notice: "Event was successfully created."
      else
        render :new, status: :unprocessable_content
      end
    end

    # PATCH/PUT /events/1
    def update
      if @event.update(event_params)
        redirect_to @event, notice: "Event was successfully updated.", status: :see_other
      else
        render :edit, status: :unprocessable_content
      end
    end

    # DELETE /events/1
    def destroy
      @event.destroy!
      redirect_to events_path, notice: "Event was successfully destroyed.", status: :see_other
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_event
        @event = Event.find(params.expect(:id))
      end

      # Only allow a list of trusted parameters through.
      def event_params
        params_with_user = params.expect(event: [
          :event_date,
          content_attributes: [:id, :title, :subtitle, :description, :cover, :user_id, :_destroy],
        ])
        params_with_user[:content_attributes][:user_id] = current_user.id
        params_with_user
      end
  end
end
