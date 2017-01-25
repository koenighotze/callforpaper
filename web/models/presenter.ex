defmodule Callforpapers.Presenter do
  use Callforpapers.Web, :model

  schema "presenters" do
    field :name, :string
    field :email, :string
    field :bio, :string
    field :picture, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    field :role, :string

    has_many :submissions, Callforpapers.Submission

    timestamps()
  end

  def is_organizer?(presenter) do
    presenter.role == "organizer"
  end

  def is_presenter?(presenter) do
    presenter.role == "presenter"
  end

  def submissions_by_presenter(presenter) do
    assoc(presenter, :submissions)
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
    |> validate_role(:role, ["presenter", "organizer"])
    |> unique_constraint(:email)
  end

  def validate_role(changeset, field, allowed, options \\ []) do
    validate_change(changeset,
                    field,
                    fn _, role ->
                      if role in allowed do
                        []
                      else
                        [{field, options[:message] || "is invalid"}]
                      end
                    end)
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
end
