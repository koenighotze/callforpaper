defmodule Callforpapers.Filing do
  use Callforpapers.Web, :model

  schema "filings" do
    field :status, :string, default: "open"
    belongs_to :submission, Callforpapers.Talk
    belongs_to :cfp, Callforpapers.Cfp

    timestamps()
  end

  def valid_states, do: ~w(open rejected accepted)

  def with_cfp(query) do
    from q in query, preload: [{:cfp, :conference}]
  end

  def with_submission(query) do
    from q in query, preload: [{:submission, :user}]
  end

  def open?(%{status: "open"}), do: true
  def open?(_), do: false

  def accepted?(%{status: "accepted"}), do: true
  def accepted?(_), do: false

  def rejected?(%{status: "rejected"}), do: true
  def rejected?(_), do: false

  def reject(filing) do
    filing
    |> changeset(%{status: "rejected"})
  end

  def accept(filing) do
    filing
    |> changeset(%{status: "accepted"})
  end

  # %{id: filing.id, presenter: filing.submission.user.name, submission_id: filing.submission.id, title: filing.submission.title, status: filing.status}
  #
  #
  def presenter(filing) do
    filing.submission.user.name
  end

  def title(filing) do
    filing.submission.title
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
