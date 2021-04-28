require 'test_helper'

class RemoveDatasToClientesControllerTest < ActionController::TestCase
  setup do
    @remove_datas_to_cliente = remove_datas_to_clientes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:remove_datas_to_clientes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create remove_datas_to_cliente" do
    assert_difference('RemoveDatasToCliente.count') do
      post :create, remove_datas_to_cliente: {  }
    end

    assert_redirected_to remove_datas_to_cliente_path(assigns(:remove_datas_to_cliente))
  end

  test "should show remove_datas_to_cliente" do
    get :show, id: @remove_datas_to_cliente
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @remove_datas_to_cliente
    assert_response :success
  end

  test "should update remove_datas_to_cliente" do
    patch :update, id: @remove_datas_to_cliente, remove_datas_to_cliente: {  }
    assert_redirected_to remove_datas_to_cliente_path(assigns(:remove_datas_to_cliente))
  end

  test "should destroy remove_datas_to_cliente" do
    assert_difference('RemoveDatasToCliente.count', -1) do
      delete :destroy, id: @remove_datas_to_cliente
    end

    assert_redirected_to remove_datas_to_clientes_path
  end
end
