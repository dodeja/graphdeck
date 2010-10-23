require 'test_helper'

class AggregateMetricMetadatasControllerTest < ActionController::TestCase
  setup do
    @aggregate_metric_metadata = aggregate_metric_metadatas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:aggregate_metric_metadatas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create aggregate_metric_metadata" do
    assert_difference('AggregateMetricMetadata.count') do
      post :create, :aggregate_metric_metadata => @aggregate_metric_metadata.attributes
    end

    assert_redirected_to aggregate_metric_metadata_path(assigns(:aggregate_metric_metadata))
  end

  test "should show aggregate_metric_metadata" do
    get :show, :id => @aggregate_metric_metadata.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @aggregate_metric_metadata.to_param
    assert_response :success
  end

  test "should update aggregate_metric_metadata" do
    put :update, :id => @aggregate_metric_metadata.to_param, :aggregate_metric_metadata => @aggregate_metric_metadata.attributes
    assert_redirected_to aggregate_metric_metadata_path(assigns(:aggregate_metric_metadata))
  end

  test "should destroy aggregate_metric_metadata" do
    assert_difference('AggregateMetricMetadata.count', -1) do
      delete :destroy, :id => @aggregate_metric_metadata.to_param
    end

    assert_redirected_to aggregate_metric_metadatas_path
  end
end
