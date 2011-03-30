require 'test_helper'

class FileCreatorsControllerTest < ActionController::TestCase
  setup do
    @file_creator = file_creators(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:file_creators)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create file_creator" do
    assert_difference('FileCreator.count') do
      post :create, :file_creator => @file_creator.attributes
    end

    assert_redirected_to file_creator_path(assigns(:file_creator))
  end

  test "should show file_creator" do
    get :show, :id => @file_creator.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @file_creator.to_param
    assert_response :success
  end

  test "should update file_creator" do
    put :update, :id => @file_creator.to_param, :file_creator => @file_creator.attributes
    assert_redirected_to file_creator_path(assigns(:file_creator))
  end

  test "should destroy file_creator" do
    assert_difference('FileCreator.count', -1) do
      delete :destroy, :id => @file_creator.to_param
    end

    assert_redirected_to file_creators_path
  end
end
