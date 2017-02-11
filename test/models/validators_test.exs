defmodule Callforpapers.ValidatorsTest do
  use Callforpapers.ModelCase
  alias Callforpapers.Validators

  defmodule Foo do
    use Callforpapers.Web, :model
    schema "filings" do
      field :field, :string, default: "open"
      field :start, :date
      field :end, :date
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

  test "validate_before detects if first date before second date" do
    res =
      %Foo{}
      |> cast(%{start: ~D{2000-10-10}, end: ~D{2000-10-11}}, [:start, :end])
      |> Validators.validate_before(:start, :end)

    assert res.valid?
  end

  test "validate_before detects if first date after second date" do
    res =
      %Foo{}
      |> cast(%{start: ~D{2000-10-12}, end: ~D{2000-10-11}}, [:start, :end])
      |> Validators.validate_before(:start, :end)

    refute res.valid?
  end

  test "validate_before detects if first date is same as second date" do
    res =
      %Foo{}
      |> cast(%{start: ~D{2000-10-11}, end: ~D{2000-10-11}}, [:start, :end])
      |> Validators.validate_before(:start, :end)

    refute res.valid?
  end
end