defmodule Callforpapers.Conference do
  use Callforpapers.Web, :model

  schema "conferences" do
    field :title, :string
    field :start, Ecto.Date
    field :end, Ecto.Date

    belongs_to :user, Callforpapers.User
    has_many :callforpapers, Callforpapers.Cfp

    timestamps()
  end

  def titles_and_ids(query) do
    from q in query, select: {q.title, q.id}
  end

  def filter_on_organizer(query, user) do
    from q in query, where: q.user_id == ^user.id
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
