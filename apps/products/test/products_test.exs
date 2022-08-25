defmodule ProductsTest do
  use ExUnit.Case

  test "should return all product list" do
    products = Products.Worker.list()
    assert length(products) == 3
  end

  test "should remove an item from stock" do
    Products.Worker.remove_from_stock(1, 2)
    product = Products.Worker.list() |> List.first()

    assert product.quantity == 8
  end
end
