require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(email: "test@example.com", password: "password", password_confirmation: "password")
    @profile = @user.profiles.create!(name: "Test Profile", username: "tester")
  end

  test "should redirect to profile selection if no profile is selected" do
    sign_in @user
    get dashboard_path
    assert_redirected_to profiles_path
  end

  test "should get dashboard index after selecting a profile" do
    sign_in @user
    post select_profile_url(@profile) # Sets session and redirects
    
    assert_redirected_to dashboard_path
    follow_redirect!

    assert_response :success
    assert_select "h2", text: "All My Stories"
  end

  test "should display empty state if user has no stories" do
    sign_in @user
    post select_profile_url(@profile)
    follow_redirect!

    assert_response :success
    assert_select ".empty-state-enhanced"
    assert_select "h3", text: "Your story library is empty"
  end

  test "should display stories on the dashboard" do
    @profile.stories.create!(title: "My First Story", status: "draft")
    @profile.stories.create!(title: "My Second Story", status: "complete")

    sign_in @user
    post select_profile_url(@profile)
    follow_redirect!

    assert_response :success
    assert_select ".stories-grid .story-card-wrapper", count: 2
    assert_select ".progress-count", text: "2"
    assert_select "p.story-title", text: "My First Story"
    assert_select "p.story-title", text: "My Second Story"
  end

  test "should display continue reading section for draft stories" do
    story = @profile.stories.create!(title: "Draft Story", status: "draft")

    sign_in @user
    post select_profile_url(@profile)
    follow_redirect!

    assert_response :success
    assert_select ".continue-reading-card"
    assert_select "p.story-title", text: "Draft Story"
    assert_select "a[href=?]", story_path(story), text: "Continue"
  end

  test "should not display continue reading section if there are no draft stories" do
    @profile.stories.create!(title: "Complete Story", status: "complete")

    sign_in @user
    post select_profile_url(@profile)
    follow_redirect!

    assert_response :success
    assert_select ".continue-reading-card", count: 0
  end

  test "should display bookmarked stories section" do
    story = @user.stories.create!(title: "Another User Story")
    @profile.bookmarks.create!(story: story)

    sign_in @user
    post select_profile_url(@profile)
    follow_redirect!

    assert_response :success
    assert_select "section.favorite-stories"
    assert_select "h2", /My favorite stories/
    assert_select ".stories-scroll .story-card-wrapper", count: 1
    assert_select "p.story-title", text: "Another User Story"
  end
end
