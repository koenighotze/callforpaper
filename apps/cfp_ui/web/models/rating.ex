defmodule CfpUi.Rating do
  use CfpUi.Web, :model

  schema "ratings" do
    belongs_to :presentation, CfpUi.Presentation
    belongs_to :user, CfpUi.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end
end
