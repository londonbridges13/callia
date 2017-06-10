require 'test_helper'

class RecurringShiftsControllerTest < ActionController::TestCase
  setup do
    @recurring_shift = recurring_shifts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:recurring_shifts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create recurring_shift" do
    assert_difference('RecurringShift.count') do
      post :create, recurring_shift: { frequency: @recurring_shift.frequency, time_span: @recurring_shift.time_span }
    end

    assert_redirected_to recurring_shift_path(assigns(:recurring_shift))
  end

  test "should show recurring_shift" do
    get :show, id: @recurring_shift
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @recurring_shift
    assert_response :success
  end

  test "should update recurring_shift" do
    patch :update, id: @recurring_shift, recurring_shift: { frequency: @recurring_shift.frequency, time_span: @recurring_shift.time_span }
    assert_redirected_to recurring_shift_path(assigns(:recurring_shift))
  end

  test "should destroy recurring_shift" do
    assert_difference('RecurringShift.count', -1) do
      delete :destroy, id: @recurring_shift
    end

    assert_redirected_to recurring_shifts_path
  end
end
