defmodule Main do
  @moduledoc """
  Documentation for `Main`.
  Here will be only interfaces function like: show products, buy products
  """
  @products_worker :"products@MacBook-Air-de-Ayaworan.local"
  @checkout_worker :"checkout@MacBook-Air-de-Ayaworan.local"

  def child_spec(args) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [args]}
    }
  end

  def start_link(args) do
    Node.start(:main)
    Node.set_cookie(:password)
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
    case :rpc.call(@checkout_worker, :"Elixir.Checkout.Worker", :buy, [id, quantity]) do
      {:badrpc, :nodedown} ->
        {:error, "node not found"}

      {:error, :out_of_stock} ->
        {:error, "Out of Stoc"}

      {:ok, product, quantity} ->
        {:ok, "#{quantity}x of #{product} bought successfully"}
    end
  end
end
