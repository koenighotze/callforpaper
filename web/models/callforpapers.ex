defmodule Callforpapers.Callforpapers do
  use Callforpapers.Web, :model

  @valid_stati ~w(open closed)

  schema "callforpapers" do
    field :start, Ecto.Date
    field :end, Ecto.Date
    field :status, :string

    belongs_to :conference, Callforpapers.Conference

    timestamps()
  end

  def titles_and_ids(query) do
    # from q in query select: {q: }
  end

  def filter_on_organizer(query) do
  end

  def valid_state?(status) do
    status in @valid_stati
  end

  def valid_stati, do: @valid_stati

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:start, :end, :status])
    |> validate_required([:start, :end, :status])
    |> Validators.validate_enum(:status, @valid_stati)
    |> assoc_constraint(:conference)
  end
end
