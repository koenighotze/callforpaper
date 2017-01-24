defmodule Callforpapers.Submission do
  use Callforpapers.Web, :model

  @required [:title, :shortsummary, :duration]
  @optional [:externallink]

  schema "submissions" do
    field :title, :string
    field :shortsummary, :string
    field :duration, :integer
    field :externallink, :string
    belongs_to :presenter, Callforpapers.Presenter

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required ++ @optional)
    |> validate_length(:title, min: 1, max: 50)
    |> validate_length(:shortsummary, min: 20, max: 200)
    |> validate_number(:duration, greater_than_or_equal_to: 20, less_than_or_equal_to: 90)
    |> assoc_constraint(:presenter)
    |> validate_required(@required)
  end
end
