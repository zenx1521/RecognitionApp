require 'test_helper'

class SessionAttachmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @session_attachment = session_attachments(:one)
  end

  test "should get index" do
    get session_attachments_url
    assert_response :success
  end

  test "should get new" do
    get new_session_attachment_url
    assert_response :success
  end

  test "should create session_attachment" do
    assert_difference('SessionAttachment.count') do
      post session_attachments_url, params: { session_attachment: { image: @session_attachment.image, session_id: @session_attachment.session_id } }
    end

    assert_redirected_to session_attachment_url(SessionAttachment.last)
  end

  test "should show session_attachment" do
    get session_attachment_url(@session_attachment)
    assert_response :success
  end

  test "should get edit" do
    get edit_session_attachment_url(@session_attachment)
    assert_response :success
  end

  test "should update session_attachment" do
    patch session_attachment_url(@session_attachment), params: { session_attachment: { image: @session_attachment.image, session_id: @session_attachment.session_id } }
    assert_redirected_to session_attachment_url(@session_attachment)
  end

  test "should destroy session_attachment" do
    assert_difference('SessionAttachment.count', -1) do
      delete session_attachment_url(@session_attachment)
    end

    assert_redirected_to session_attachments_url
  end
end
