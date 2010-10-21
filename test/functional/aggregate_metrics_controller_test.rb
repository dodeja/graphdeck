require 'test_helper'

class AggregateMetricsControllerTest < ActionController::TestCase
  setup do
    @aggregate_metric = aggregate_metrics(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:aggregate_metrics)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create aggregate_metric" do
    assert_difference('AggregateMetric.count') do
      post :create, :aggregate_metric => @aggregate_metric.attributes
    end

    assert_redirected_to aggregate_metric_path(assigns(:aggregate_metric))
  end

  test "should show aggregate_metric" do
    get :show, :id => @aggregate_metric.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @aggregate_metric.to_param
    assert_response :success
  end

  test "should update aggregate_metric" do
    put :update, :id => @aggregate_metric.to_param, :aggregate_metric => @aggregate_metric.attributes
    assert_redirected_to aggregate_metric_path(assigns(:aggregate_metric))
  end

  test "should destroy aggregate_metric" do
    assert_difference('AggregateMetric.count', -1) do
      delete :destroy, :id => @aggregate_metric.to_param
    end

    assert_redirected_to aggregate_metrics_path
  end
end
