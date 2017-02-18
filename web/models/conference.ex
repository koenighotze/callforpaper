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
    |> unique_constraint(:title, name: :conferences_title_index)
    |> assoc_constraint(:user)
    |> Validators.validate_before(:start, :end)
  end

  defimpl String.Chars, for: Callforpapers.Conference do
    def to_string(conf) do
      "#{conf.start}-#{conf.end} #{conf.title}"
    end
  end
end
