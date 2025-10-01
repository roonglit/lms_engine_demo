require "test_helper"

module Lms
  class PostControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get new" do
      get post_new_url
      assert_response :success
    end
  end
end
