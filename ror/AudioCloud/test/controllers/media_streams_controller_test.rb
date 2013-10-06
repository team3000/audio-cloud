require 'test_helper'

class MediaStreamsControllerTest < ActionController::TestCase
  setup do
    @media_stream = media_streams(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:media_streams)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create media_stream" do
    assert_difference('MediaStream.count') do
      post :create, media_stream: { detail: @media_stream.detail, download_url: @media_stream.download_url, duration: @media_stream.duration, image_url: @media_stream.image_url, likes: @media_stream.likes, media_type: @media_stream.media_type, name: @media_stream.name, permalink_url: @media_stream.permalink_url, url: @media_stream.url }
    end

    assert_redirected_to media_stream_path(assigns(:media_stream))
  end

  test "should show media_stream" do
    get :show, id: @media_stream
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @media_stream
    assert_response :success
  end

  test "should update media_stream" do
    patch :update, id: @media_stream, media_stream: { detail: @media_stream.detail, download_url: @media_stream.download_url, duration: @media_stream.duration, image_url: @media_stream.image_url, likes: @media_stream.likes, media_type: @media_stream.media_type, name: @media_stream.name, permalink_url: @media_stream.permalink_url, url: @media_stream.url }
    assert_redirected_to media_stream_path(assigns(:media_stream))
  end

  test "should destroy media_stream" do
    assert_difference('MediaStream.count', -1) do
      delete :destroy, id: @media_stream
    end

    assert_redirected_to media_streams_path
  end
end
