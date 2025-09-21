require "application_system_test_case"

module Lms
  class Admin::CoursesTest < ApplicationSystemTestCase
    setup do
      @admin_course = lms_admin_courses(:one)
    end

    test "visiting the index" do
      visit admin_courses_url
      assert_selector "h1", text: "Courses"
    end

    test "should create course" do
      visit admin_courses_url
      click_on "New course"

      click_on "Create Course"

      assert_text "Course was successfully created"
      click_on "Back"
    end

    test "should update Course" do
      visit admin_course_url(@admin_course)
      click_on "Edit this course", match: :first

      click_on "Update Course"

      assert_text "Course was successfully updated"
      click_on "Back"
    end

    test "should destroy Course" do
      visit admin_course_url(@admin_course)
      click_on "Destroy this course", match: :first

      assert_text "Course was successfully destroyed"
    end
  end
end
