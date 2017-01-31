defmodule Callforpapers.Conference do
  use Callforpapers.Web, :model

  schema "conferences" do
    field :title, :string
    field :start, Ecto.Date
    field :end, Ecto.Date

    belongs_to :user, Callforpapers.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :start, :end])
    |> validate_required([:title, :start, :end])
    |> validate_length(:title, min: 10, max: 50)
    |> assoc_constraint(:user)
  end
end
