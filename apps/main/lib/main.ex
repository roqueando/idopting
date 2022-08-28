defmodule Main do
  @moduledoc """
  Documentation for `Main`.
  Here will be only interfaces function like: show products, buy products
  """
  @products_worker :"idopting-products@fdaa:0:8cd8:a7b:1f61:5d29:4a:2"
  @checkout_worker :"idopting-checkout@fdaa:0:8cd8:a7b:1f60:2f6a:c1cd:2"

  def child_spec(args) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [args]}
    }
  end

  def start_link(args) do
    #Node.set_cookie(:password)
    GenServer.start_link(__MODULE__, args)
  end

  def init(_), do: {:ok, []}

  @doc """
  Calls product worker `list/0` and return all products.
  """
  def list_products do
    case :rpc.call(@products_worker, :"Elixir.Products.Worker", :list, []) do
      {:badrpc, :nodedown} ->
        {:error, "node not found"}

      products ->
        products
    end
  end

  @doc """
  Calls checkout worker `buy/2` and return the bought product.
  """
  def buy_product(id, quantity \\ 1) do
    :rpc.cast(@checkout_worker, :"Elixir.Checkout", :buy, [id, quantity])
    IO.puts("Processing your payment")
  end

  def product_worker, do: @products_worker
  def checkout_worker, do: @checkout_worker
end
