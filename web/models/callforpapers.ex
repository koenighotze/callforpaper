defmodule Callforpapers.Callforpapers do
  use Callforpapers.Web, :model

  schema "callforpapers" do
    field :start, Ecto.Date
    field :end, Ecto.Date
    field :status, :string
    belongs_to :conference, Callforpapers.Conference

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:start, :end, :status])
    |> validate_required([:start, :end, :status])
  end
end
