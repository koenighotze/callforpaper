defmodule Callforpapers.Filing do
  use Callforpapers.Web, :model

  schema "filings" do
    field :status, :string, default: "open"
    belongs_to :submission, Callforpapers.Submission
    belongs_to :cfp, Callforpapers.Cfp

    timestamps()
  end

  def valid_states, do: ~w(open rejected accepted)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:status])
    |> validate_required([:status])
    |> Validators.validate_enum(:status, valid_states)
  end
end
