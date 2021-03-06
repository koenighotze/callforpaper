defmodule Callforpapers.Cfp do
  use Callforpapers.Web, :model

  @valid_stati ~w(open closed)

  schema "callforpapers" do
    field :start, Ecto.Date
    field :end, Ecto.Date
    field :status, :string

    belongs_to :conference, Callforpapers.Conference
# TODO:        has_many :submissions, Callforpapers.Submission

    timestamps()
  end

  def only_open(query) do
    from s in query, where: s.status == "open"
  end

  def with_conference(query) do
    from s in query, preload: [:conference]
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
    |> cast_assoc(:conference)
    |> Validators.validate_before(:start, :end)
    |> unique_constraint(:conference_id, name: :callforpapers_conference_id_index, message: "A conference may only have a single CfP.")
  end

  defimpl String.Chars, for: Callforpapers.Cfp do
    def to_string(cfp) do
      "#{cfp.start}-#{cfp.end} #{cfp.status}"
    end
  end
end
