require "application_system_test_case"

class PodcastsTest < ApplicationSystemTestCase
  setup do
    @podcast = podcasts(:one)
  end

  test "visiting the index" do
    visit podcasts_url
    assert_selector "h1", text: "Podcasts"
  end

  test "creating a Podcast" do
    visit podcasts_url
    click_on "New Podcast"

    fill_in "Name", with: @podcast.name
    fill_in "Path", with: @podcast.path
    click_on "Create Podcast"

    assert_text "Podcast was successfully created"
    click_on "Back"
  end

  test "updating a Podcast" do
    visit podcasts_url
    click_on "Edit", match: :first

    fill_in "Name", with: @podcast.name
    fill_in "Path", with: @podcast.path
    click_on "Update Podcast"

    assert_text "Podcast was successfully updated"
    click_on "Back"
  end

  test "destroying a Podcast" do
    visit podcasts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Podcast was successfully destroyed"
  end
end
