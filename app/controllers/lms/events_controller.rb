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
      @categories = Category.all
    end

    # GET /events/1/edit
    def edit
      @categories = Category.all
    end

    def join
      @event = Event.find(params[:id])
      external_event_id = @event.external_event_id
      unless external_event_id
        return redirect_to @event, alert: "ไม่พบ Graph Event ID ของอีเวนต์นี้"
      end

      # access_token = 
      access_token = Rails.cache.read("ms:kanin@odds.com:access_token")
      uri = URI("https://graph.microsoft.com/v1.0/me/events/#{external_event_id}")
      req = Net::HTTP::Patch.new(uri)
      req["Authorization"] = "Bearer #{access_token}"
      req["Content-Type"] = "application/json"

      req.body = {
        attendees: [
          {
            emailAddress: {
              address: "pi@odds.team", 
              name: "ปี"
            },
            type: "required"
          }
        ]
      }.to_json

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(req)
      end

      if res.is_a?(Net::HTTPSuccess)
        puts "✅ Added attendee successfully"
        redirect_to @event, notice: "เข้าร่วมอีเวนต์เรียบร้อยแล้ว!"
      else
        puts "❌ Failed: #{res.code} - #{res.body}"
        redirect_to @event, notice: "เข้าร่วมอีเวนต์เรียบร้อยแล้ว!"
      end
    end

    # POST /events
    def create
      @event = Event.new(event_params)
      if @event.save
        call_api_get_keycloak_token and return
      else
        @categories = Category.all
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /events/1
    def update
      if @event.update(event_params)
        redirect_to @event, notice: "Event was successfully updated.", status: :see_other
      else
        @categories = Category.all
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /events/1
    def destroy
      @event.destroy!
      redirect_to events_path, notice: "Event was successfully destroyed.", status: :see_other
    end

    private

      def microsoft_access_token!
          token = session[:ms_access_token]
          return token if token.present?

          if current_user&.token
            uri = URI("http://localhost:8080/realms/lms/broker/microsoft/token")
            req = Net::HTTP::Get.new(uri)
            req["Authorization"] = "Bearer #{current_user.token}"

            res = Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(req) }
            if res.is_a?(Net::HTTPSuccess)
              body = JSON.parse(res.body)
              session[:ms_access_token] = body["access_token"]
              return session[:ms_access_token]
            end
          end

          Rails.cache.read("ms_access_token")
        rescue
          nil
      end

      def set_event
        @event = Event.find(params[:id])
      end

      def event_params
        permitted = params
          .require(:event)
          .permit(
            :event_date,
            :external_provider,
            :external_event_id,
            :external_ical_uid,
            :external_web_link,
            :online_meeting_url,
            :external_etag,
            :synced_at,
            content_attributes: [
              :id, :title, :subtitle, :description, :cover, :user_id, :_destroy,
              { category_ids: [] }
            ]
          )

        permitted[:content_attributes] ||= {}
        permitted[:content_attributes][:user_id] = current_user.id
        permitted
      end

      def call_api_get_keycloak_token
        uri = URI("http://localhost:8080/realms/lms/broker/microsoft/token")

        req = Net::HTTP::Get.new(uri)
        req["Authorization"] = "Bearer #{current_user.token}"

        res = Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(req) }

        if res.is_a?(Net::HTTPSuccess)
          Rails.logger.info "call_api_get_keycloak_token:: PASS"
          token_data = JSON.parse(res.body)
          create_teams_event(token_data: token_data) and return
        else
          Rails.logger.error "call_api_get_keycloak_token:: ERROR (#{res.code})"
          redirect_to main_app.destroy_user_session_path, alert: "Session expired. Please sign in again." and return
        end
      end

      def create_teams_event(token_data:)
        if token_data.blank?
          render json: { error: "No token in session, please re-authenticate" }, status: :unauthorized and return
        end

        access_token = token_data["access_token"]
        uri = URI("https://graph.microsoft.com/v1.0/me/events")

        req = Net::HTTP::Post.new(uri)
        req["Authorization"] = "Bearer #{access_token}"
        req["Content-Type"] = "application/json"

        event = @event || Event.last
        start_time = Time.zone.parse("#{event.event_date} 09:00").iso8601
        end_time   = Time.zone.parse("#{event.event_date} 10:00").iso8601

        req.body = {
          subject: "Meeting for #{event.content.title}",
          start: { dateTime: start_time, timeZone: "Asia/Bangkok" },
          end:   { dateTime: end_time,   timeZone: "Asia/Bangkok" },
          isOnlineMeeting: true,
          onlineMeetingProvider: "teamsForBusiness",
          attendees: [
            {
              emailAddress: { address: "kanin@odds.com", name: "กบ" },
              type: "required"
            }
          ]
        }.to_json

        res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }

        if res.is_a?(Net::HTTPSuccess)
          Rails.logger.info "create_teams_event:: PASS"
          Rails.cache.write("ms:kanin@odds.com:access_token", access_token, expires_in: 55.minutes)
          graph_json = JSON.parse(res.body)

          @event.update(
            external_provider:   "microsoft",
            external_event_id:   graph_json["id"],
            external_ical_uid:   graph_json["iCalUId"],
            external_web_link:   graph_json["webLink"],
            online_meeting_url:  graph_json.dig("onlineMeeting", "joinUrl"),
            external_etag:       graph_json["@odata.etag"],
            synced_at:           Time.current
          )

          redirect_to lms.root_path, notice: "Event was successfully created (and Teams meeting created)." and return
        else
          Rails.logger.error "create_teams_event:: ERROR (#{res.code}) #{res.body}"
          render json: { success: false, code: res.code, body: res.body }, status: :bad_request and return
        end
      end
  end
end
