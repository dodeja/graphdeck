require 'test_helper'

class NamespacesControllerTest < ActionController::TestCase
  setup do
    @namespace = namespaces(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:namespaces)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create namespace" do
    assert_difference('Namespace.count') do
      post :create, :namespace => @namespace.attributes
    end

    assert_redirected_to namespace_path(assigns(:namespace))
  end

  test "should show namespace" do
    get :show, :id => @namespace.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @namespace.to_param
    assert_response :success
  end

  test "should update namespace" do
    put :update, :id => @namespace.to_param, :namespace => @namespace.attributes
    assert_redirected_to namespace_path(assigns(:namespace))
  end

  test "should destroy namespace" do
    assert_difference('Namespace.count', -1) do
      delete :destroy, :id => @namespace.to_param
    end

    assert_redirected_to namespaces_path
  end
end
