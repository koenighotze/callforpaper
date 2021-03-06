defmodule Callforpapers.User do
  use Callforpapers.Web, :model

  alias Callforpapers.Talk

  schema "users" do
    field :name, :string
    field :email, :string
    field :bio, :string
    field :picture, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    field :role, :string, default: "presenter"

    has_many :talks, Callforpapers.Talk
    has_many :conferences, Callforpapers.Conference

    timestamps()
  end

  def filter_on_presesenters(query) do
    query # todo
  end

  def is_organizer?(user) do
    user.role == "organizer"
  end

  def is_presenter?(user) do
    user.role == "presenter"
  end

  def talks_by_presenter(user) do
    assoc(user, :talks)
  end

  def alphabetical(query) do
    from q in query, order_by: q.name
  end

  def names_and_ids(query) do
    from q in query, select: {q.name, q.id}
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :email, :bio, :picture, :role])
    |> validate_required([:name, :email, :bio, :role])
    |> Validators.validate_enum(:role, ["presenter", "organizer"])
    |> unique_constraint(:email)
  end

  def registration_changeset(model, params \\ :empty) do
    model
    |> changeset(params)
    |> cast(params, ~w(password))
    |> validate_length(:password, min: 8, max: 20)
    |> put_pass_hash()
  end

  def put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pw}} -> put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pw))
      _ -> changeset
    end
  end

  def add_talk(user, talk_params) do
    user
      |> build_assoc(:talks)
      |> Talk.changeset(talk_params)
      |> validate_unique_title(user)
  end

  def validate_unique_title(changeset, user) do
    validate_change(changeset,
                    :title,
                    fn _, title ->
                      talk = Talk.talk_with_title(user, title) |> Callforpapers.Repo.one
                      if nil == talk do
                        []
                      else
                        [{:title, "is already taken."}]
                      end
                    end)
  end


end
