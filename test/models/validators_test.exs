defmodule Callforpapers.ValidatorsTest do
  use Callforpapers.ModelCase
  alias Callforpapers.Validators

  defmodule Foo do
    use Callforpapers.Web, :model
    schema "filings" do
      field :field, :string, default: "open"
    end
  end

  test "validate_enum accepts valid enums" do
    res =
      change(%Foo{}, %{field: "foo"})
      |> Validators.validate_enum(:field, ~w(foo bar))

    assert res.valid?
  end

  test "validate_enum detects invalid enums" do
    res =
      change(%Foo{}, %{field: "baz"})
      |> Validators.validate_enum(:field, ~w(foo bar))

    refute res.valid?
  end
end