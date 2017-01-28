defmodule Callforpapers.Conference do
  use Callforpapers.Web, :model

  schema "conferences" do
    field :title, :string
    field :start, Ecto.Date
    field :end, Ecto.Date

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :start, :end])
    |> validate_required([:title, :start, :end])
  end
end
