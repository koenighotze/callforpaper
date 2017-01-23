defmodule CfpUi.Submission do
  use CfpUi.Web, :model

  schema "submissions" do
    field :title, :string
    field :short_description, :string
    field :reference, :string
    field :duration_minutes, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :short_description, :reference, :duration_minutes])
    |> validate_required([:title, :short_description, :reference, :duration_minutes])
  end
end
