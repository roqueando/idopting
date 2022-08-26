defmodule Products.Worker do
  @moduledoc """
  Documentation for `Products.Worker`.
  """
  @main_cookie :password

  use Agent

  def start_link(opts) do
    Node.start(:products)
    Node.set_cookie(@main_cookie)

    Agent.start_link(
      fn ->
        [
          %{id: 1, title: "Book: Neovim is awesooome", price: 14.90, quantity: 10},
          %{id: 2, title: "Book: Agile with Pigor", price: 14.90, quantity: 10},
          %{id: 3, title: "Mechanical keyboard", price: 14.90, quantity: 10}
        ]
      end,
      opts
    )
  end

  def init(_) do
    {:ok, []}
  end

  @doc """
  Return all products
  """
  def list do
    Agent.get(__MODULE__, fn state -> state end)
  end

  defp get_one(id) do
    Agent.get(__MODULE__, fn state -> Enum.find(state, fn product -> product.id == id end) end)
  end

  def remove_from_stock(id, quantity \\ 1) do
    Agent.update(__MODULE__, fn state ->
      Enum.map(state, &update_product(&1, id, quantity))
    end)

    product = get_one(id)

    case product.quantity do
      0 ->
        {:error, :out_of_stock}

      _ ->
        {:ok, product.title, quantity}
    end
  end

  defp update_product(element, id, quantity) do
    if element.id == id do
      Map.put(
        element,
        :quantity,
        if(element.quantity == 0, do: 0, else: element.quantity - quantity)
      )
    else
      element
    end
  end
end
