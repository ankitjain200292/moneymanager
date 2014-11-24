require 'test_helper'

class FinancialAccountsControllerTest < ActionController::TestCase
  setup do
    @financial_account = financial_accounts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:financial_accounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create financial_account" do
    assert_difference('FinancialAccount.count') do
      post :create, financial_account: { account_type_id: @financial_account.account_type_id, actual_payment: @financial_account.actual_payment, balance: @financial_account.balance, company_name: @financial_account.company_name, min_payment: @financial_account.min_payment, original_balance: @financial_account.original_balance, rate: @financial_account.rate, user_id: @financial_account.user_id }
    end

    assert_redirected_to financial_account_path(assigns(:financial_account))
  end

  test "should show financial_account" do
    get :show, id: @financial_account
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @financial_account
    assert_response :success
  end

  test "should update financial_account" do
    patch :update, id: @financial_account, financial_account: { account_type_id: @financial_account.account_type_id, actual_payment: @financial_account.actual_payment, balance: @financial_account.balance, company_name: @financial_account.company_name, min_payment: @financial_account.min_payment, original_balance: @financial_account.original_balance, rate: @financial_account.rate, user_id: @financial_account.user_id }
    assert_redirected_to financial_account_path(assigns(:financial_account))
  end

  test "should destroy financial_account" do
    assert_difference('FinancialAccount.count', -1) do
      delete :destroy, id: @financial_account
    end

    assert_redirected_to financial_accounts_path
  end
end
