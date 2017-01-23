defmodule CfpUi.User do
  use CfpUi.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :bio, :string
    field :profile, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :email, :bio, :profile])
    |> validate_required([:name, :email, :bio, :profile])
  end
end
