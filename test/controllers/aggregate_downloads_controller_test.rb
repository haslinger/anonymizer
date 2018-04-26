require 'test_helper'

class AggregateDownloadsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @aggregate_download = aggregate_downloads(:one)
  end

  test "should get index" do
    get aggregate_downloads_url
    assert_response :success
  end

  test "should get new" do
    get new_aggregate_download_url
    assert_response :success
  end

  test "should create aggregate_download" do
    assert_difference('AggregateDownload.count') do
      post aggregate_downloads_url, params: { aggregate_download: { count: @aggregate_download.count, day: @aggregate_download.day, episode_id: @aggregate_download.episode_id, hits: @aggregate_download.hits, volume: @aggregate_download.volume } }
    end

    assert_redirected_to aggregate_download_url(AggregateDownload.last)
  end

  test "should show aggregate_download" do
    get aggregate_download_url(@aggregate_download)
    assert_response :success
  end

  test "should get edit" do
    get edit_aggregate_download_url(@aggregate_download)
    assert_response :success
  end

  test "should update aggregate_download" do
    patch aggregate_download_url(@aggregate_download), params: { aggregate_download: { count: @aggregate_download.count, day: @aggregate_download.day, episode_id: @aggregate_download.episode_id, hits: @aggregate_download.hits, volume: @aggregate_download.volume } }
    assert_redirected_to aggregate_download_url(@aggregate_download)
  end

  test "should destroy aggregate_download" do
    assert_difference('AggregateDownload.count', -1) do
      delete aggregate_download_url(@aggregate_download)
    end

    assert_redirected_to aggregate_downloads_url
  end
end
