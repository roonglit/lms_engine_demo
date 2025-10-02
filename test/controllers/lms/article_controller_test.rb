require "test_helper"

module Lms
  class ArticleControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get new" do
      get article_new_url
      assert_response :success
    end

    test "should get edit" do
      get article_edit_url
      assert_response :success
    end
  end
end
