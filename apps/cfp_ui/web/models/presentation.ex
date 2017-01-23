defmodule CfpUi.Presentation do
  use CfpUi.Web, :model

  schema "presentations" do
    field :held_at, Ecto.DateTime
    field :held_where, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:held_at, :held_where])
    |> validate_required([:held_at, :held_where])
  end
end
