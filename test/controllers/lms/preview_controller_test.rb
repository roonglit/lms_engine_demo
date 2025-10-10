require "test_helper"

module Lms
  class PreviewControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get preview" do
      get preview_preview_url
      assert_response :success
    end
  end
end
