defmodule Callforpapers.Filing do
  use Callforpapers.Web, :model

  schema "filings" do
    field :status, :string, default: "open"
    belongs_to :submission, Callforpapers.Submission
    belongs_to :cfp, Callforpapers.Cfp

    timestamps()
  end

  def valid_states, do: ~w(open rejected accepted)

  def with_cfp(query) do
    from q in query, preload: [{:cfp, :conference}]
  end

  def with_submission(query) do
    from q in query, preload: :submission
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:status, :submission_id, :cfp_id])
    |> validate_required([:status])
    |> Validators.validate_enum(:status, valid_states)
    |> assoc_constraint(:submission)
    |> assoc_constraint(:cfp)
  end
end
