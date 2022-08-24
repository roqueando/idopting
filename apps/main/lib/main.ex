defmodule Main do
  @moduledoc """
  Documentation for `Main`.
  Here will be only interfaces function like: show products, buy products
  """
  @products_worker :"products@MacBook-Air-de-Ayaworan.local"

  def child_spec(args) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [args]}
    }
  end

  def start_link(_args) do
    Node.start(:main)
  end

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
end
