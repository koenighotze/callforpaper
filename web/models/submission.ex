defmodule Callforpapers.Submission do
  use Callforpapers.Web, :model

  schema "submissions" do
    field :status, :string, default: "open"
    belongs_to :talk, Callforpapers.Talk
    belongs_to :cfp, Callforpapers.Cfp

    timestamps()
  end

  def valid_states, do: ~w(open rejected accepted)

  def with_cfp(query) do
    from q in query, preload: [{:cfp, :conference}]
  end

  def with_talk(query) do
    from q in query, preload: [{:talk, :user}]
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

  def presenter(filing) do
    filing.talk.user.name
  end

  def title(filing) do
    filing.talk.title
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:status, :talk_id, :cfp_id])
    |> validate_required([:status, :talk_id, :cfp_id])
    |> Validators.validate_enum(:status, valid_states)
    |> assoc_constraint(:talk)
    |> assoc_constraint(:cfp)
    |> unique_constraint(:cfp_id, name: :filings_submission_id_cfp_id_index, message: "A talk cannot be submitted twice to the same conference")
  end
end
