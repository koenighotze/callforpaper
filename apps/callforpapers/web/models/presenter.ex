defmodule Callforpapers.Presenter do
  use Callforpapers.Web, :model

  schema "presenters" do
    field :name, :string
    field :email, :string
    field :bio, :string
    field :picture, :string

    # has_many :submissions, Callforpapers.Submission

    timestamps()
  end

  def alphabetical(query) do
    from q in query, order_by: q.name
  end

  def names_and_ids(query) do
    from q in query, select: {q.name, q.id}
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :email, :bio, :picture])
    |> validate_required([:name, :email, :bio, :picture])
  end
end
