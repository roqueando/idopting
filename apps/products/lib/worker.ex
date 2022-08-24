defmodule Products.Worker do
  @moduledoc """
  Documentation for `Products.Worker`.
  """
  use GenServer

  def start_link(opts) do
    Node.start(:products)
    GenServer.start_link(__MODULE__, opts)
  end

  def init(_) do
    {:ok, []}
  end

  @doc """
  Return all products
  """
  def list do
    [
      %{title: "Book: Neovim is awesooome", price: 14.90, quantity: 10},
      %{title: "Book: Agile with Pigor", price: 14.90, quantity: 10},
      %{title: "Mechanical keyboard", price: 14.90, quantity: 10}
    ]
  end
end
