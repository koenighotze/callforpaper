defmodule Callforpapers.Talk do
  use Callforpapers.Web, :model

  @required [:title, :shortsummary, :duration]
  @optional [:externallink]

  schema "submissions" do
    field :title, :string
    field :shortsummary, :string
    field :duration, :integer
    field :externallink, :string

    belongs_to :user, Callforpapers.User

    timestamps()
  end

  def title_and_id(query) do
    from s in query, select: {s.title, s.id}
  end

  def with_presenter(query) do
    from s in query, preload: [:user]
  end

  def talks(user) do
    from t in Callforpapers.Talk, where: t.user_id == ^user.id
  end

  def talk_with_title(user, title) do
    talks = talks(user)

    from t in talks, where: t.title == ^title
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
    |> assoc_constraint(:user)
    |> validate_required(@required)
  end
end
