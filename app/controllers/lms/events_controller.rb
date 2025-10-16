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
      p = "call_api_get_keycloak_token"
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
      Rails.cache.write("ms:kanin@odds.com:access_token",access_token,expires_in: 1.hour)
      
      # 1) เตรียมข้อมูลจาก @event
      event = @event || Event.last
      start_time = Time.zone.parse("#{event.event_date} 09:00").iso8601
      end_time   = Time.zone.parse("#{event.event_date} 10:00").iso8601
      subject    = "Meeting for #{event.content.title}"

      # 2) สร้างห้อง Teams (onlineMeeting) พร้อมอัดอัตโนมัติ
      om = create_online_meeting!(
        access_token: access_token,
        start_at: start_time,
        end_at: end_time,
        auto_record: true
      )

      # 3) สร้าง Calendar Event “โดยไม่ให้สร้างห้องใหม่”
      ev = create_calendar_event_with_join_url!(
        access_token: access_token,
        subject: subject,
        start_time: start_time,
        end_time: end_time,
        join_url: om[:joinWebUrl],
        attendee_email: "#{event.content.user.email}", # จะเปลี่ยน/เพิ่มทีหลังได้
        attendee_name:  "#{event.content.user.email}"
      )

      # 4) อัปเดตลง DB
      event.update!(
        external_provider:   "microsoft_teams",       # ให้ตรง enum ของกบ
        external_event_id:   ev["id"],
        external_ical_uid:   ev["iCalUId"],
        external_web_link:   ev["webLink"],
        online_meeting_url:  om[:joinWebUrl],         # ใช้จาก onlineMeeting
        external_etag:       ev["@odata.etag"],
        synced_at:           Time.current
      )

      Rails.cache.write("ms:#{event.content.user.email}:access_token", access_token, expires_in: 55.minutes)
      redirect_to lms.root_path, notice: "Event + Teams (auto-record) สร้างสำเร็จ" and return

      rescue => e
        Rails.logger.error "create_teams_event:: ERROR #{e.class} #{e.message}"
        render json: { success: false, error: e.message }, status: :bad_request and return
    end

    def add_attendee

      @event = Event.find(params[:id])
      external_event_id = @event.external_event_id
      unless external_event_id
        return redirect_to @event, alert: "ไม่พบ Graph Event ID ของอีเวนต์นี้"
      end

      base = "https://graph.microsoft.com/v1.0/me/events/#{external_event_id}"

      # email คนเข้าร่วม
      new_email = "pi@odds.team"
      new_name = "pi"
      access_token = Rails.cache.read("ms:kanin@odds.com:access_token")

      # 1) ดึง attendees ปัจจุบัน
      uri_get = URI("#{base}?$select=attendees")
      req_get = Net::HTTP::Get.new(uri_get)
      req_get["Authorization"] = "Bearer #{access_token}"

      attendees = Net::HTTP.start(uri_get.hostname, uri_get.port, use_ssl: true) do |http|
        res = http.request(req_get)
        raise(res.body) unless res.is_a?(Net::HTTPSuccess)
        JSON.parse(res.body).fetch("attendees", [])
      end

      # 2) merge คนใหม่ (กันซ้ำตาม email)
      normalized = attendees.index_by { |a| a.dig("emailAddress", "address").to_s.downcase }
      normalized[new_email.downcase] ||= {
        "emailAddress" => { "address" => new_email, "name" => new_name },
        "type" => "required"
      }
      merged_attendees = normalized.values

      # 3) PATCH เฉพาะ attendees กลับไป (จะส่งอัปเดตเฉพาะคนที่เปลี่ยน)
      uri_patch = URI(base)
      req_patch = Net::HTTP::Patch.new(uri_patch)
      req_patch["Authorization"] = "Bearer #{access_token}"
      req_patch["Content-Type"] = "application/json"
      req_patch.body = { attendees: merged_attendees }.to_json

      Net::HTTP.start(uri_patch.hostname, uri_patch.port, use_ssl: true) do |http|
        res = http.request(req_patch)
        raise(res.body) unless res.is_a?(Net::HTTPSuccess)
        JSON.parse(res.body)
      end
    end

    private

      def create_online_meeting!(access_token:, start_at:, end_at:, auto_record: true)
        uri = URI("https://graph.microsoft.com/v1.0/me/onlineMeetings")
        req = Net::HTTP::Post.new(uri)
        req["Authorization"] = "Bearer #{access_token}"
        req["Content-Type"]  = "application/json"
        req.body = {
          startDateTime: start_at,
          endDateTime:   end_at,
          recordAutomatically: auto_record,
          isEntryExitAnnounced: false
          # ไม่ใส่ participants ก็ได้ → organizer = เจ้าของ token และเป็น presenter อัตโนมัติ
        }.to_json

        res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |h| h.request(req) }
        raise "OnlineMeeting error #{res.code}: #{res.body}" unless res.is_a?(Net::HTTPSuccess)
        data = JSON.parse(res.body)
        {
          id: data["id"],
          joinWebUrl: data["joinWebUrl"],
          raw: data
        }
      end

      def create_calendar_event_with_join_url!(access_token:, subject:, start_time:, end_time:, join_url:, attendee_email:, attendee_name:)
        uri = URI("https://graph.microsoft.com/v1.0/me/events")
        req = Net::HTTP::Post.new(uri)
        req["Authorization"] = "Bearer #{access_token}"
        req["Content-Type"]  = "application/json"

        payload = {
          subject: subject,
          start: { dateTime: start_time, timeZone: "Asia/Bangkok" },
          end:   { dateTime: end_time,   timeZone: "Asia/Bangkok" },
          location: { displayName: "Microsoft Teams" },
          body: {
            contentType: "HTML",
            content: <<~HTML
              <p>กดเข้าประชุม: <a href="#{join_url}">Join Teams</a></p>
              <p>ถ้าเข้าลิงก์ไม่ได้ ให้ใช้ลิงก์นี้: #{join_url}</p>
            HTML
          },
          attendees: [
            {
              emailAddress: { address: attendee_email, name: attendee_name },
              type: "required"
            }
          ]
        }

        req.body = payload.to_json
        res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |h| h.request(req) }
        raise "Create Event error #{res.code}: #{res.body}" unless res.is_a?(Net::HTTPSuccess)
        JSON.parse(res.body)
      end
  end
end
