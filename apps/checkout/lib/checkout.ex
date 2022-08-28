defmodule Checkout do
  @moduledoc """
  Documentation for `Checkout`.
  """
  @products_worker :"idopting-products@fdaa:0:8cd8:a7b:1f61:5d29:4a:2"

  def child_spec(args) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [args]}
    }
  end

  def start_link(args) do
    Node.set_cookie(:password)
    GenServer.start_link(__MODULE__, args)
  end

  def init(_), do: {:ok, []}

  @doc """
  Calculates a fucking long process to simulate a payment process

  """
  def buy(product_id, quantity \\ 1) do
    with {:ok, success_message} <- discount_product_stock(product_id, quantity),
         _result <- fibonacci(43) do
      IO.puts(success_message)
      {:ok, success_message}
    else
      {:error, :out_of_stock} -> IO.puts("Out of stock")
    end
  end

  def fibonacci(number) when number <= 2, do: 1

  def fibonacci(number) do
    fibonacci(number - 1) + fibonacci(number - 2)
  end

  defp discount_product_stock(id, quantity) do
    case :rpc.call(@products_worker, :"Elixir.Products.Worker", :remove_from_stock, [id, quantity]) do
      {:ok, product, qtd} ->
        {:ok, "#{qtd}x of #{product} bought successfully"}

      {:error, :out_of_stock} ->
        {:error, :out_of_stock}

      {:badrpc, :nodedown} ->
        {:error, "node not found"}
    end
  end
end
