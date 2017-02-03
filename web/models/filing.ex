defmodule Callforpapers.Filing do
  use Callforpapers.Web, :model

  schema "filings" do
    field :status, :string
    belongs_to :submission, Callforpapers.Submission
    belongs_to :cfp, Callforpapers.Cfp

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:status])
    |> validate_required([:status])
  end
end
