require "application_system_test_case"

class DownloadsTest < ApplicationSystemTestCase
  setup do
    @download = downloads(:one)
  end

  test "visiting the index" do
    visit downloads_url
    assert_selector "h1", text: "Aggregate Downloads"
  end

  test "creating a Aggregate download" do
    visit downloads_url
    click_on "New Aggregate Download"

    fill_in "Count", with: @download.count
    fill_in "Day", with: @download.day
    fill_in "Episode", with: @download.episode_id
    fill_in "Hits", with: @download.hits
    fill_in "Volume", with: @download.volume
    click_on "Create Aggregate download"

    assert_text "Aggregate download was successfully created"
    click_on "Back"
  end

  test "updating a Aggregate download" do
    visit downloads_url
    click_on "Edit", match: :first

    fill_in "Count", with: @download.count
    fill_in "Day", with: @download.day
    fill_in "Episode", with: @download.episode_id
    fill_in "Hits", with: @download.hits
    fill_in "Volume", with: @download.volume
    click_on "Update Aggregate download"

    assert_text "Aggregate download was successfully updated"
    click_on "Back"
  end

  test "destroying a Aggregate download" do
    visit downloads_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Aggregate download was successfully destroyed"
  end
end
