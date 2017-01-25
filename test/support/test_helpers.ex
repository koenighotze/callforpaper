defmodule Callforpapers.TestHelpers do
  import Ecto.Query
  import Ecto
  alias Callforpapers.Repo
  alias Callforpapers.Presenter
  alias Callforpapers.Submission

  @default_presenter %{name: "Bratislav Metulski", email: "brasis@lav.se", bio: "None of your business", picture: "", password: "12345678", role: "presenter"}
  @default_submission %{duration: 42, shortsummary: "some cadsasddasadsadsadsdasadsadsontent", title: "some content"}

  def insert_organizer(attrs \\ %{}) do
    insert_presenter(Dict.merge(attrs, %{role: "organizer"}))
  end

  def insert_presenter(attrs \\ %{}) do
    changes = Dict.merge(@default_presenter, attrs)

    %Presenter{}
    |> Presenter.registration_changeset(changes)
    |> Repo.insert!()
  end

  def insert_submission(presenter, attrs \\ %{}) do
    changes = Dict.merge(@default_submission, attrs)
    presenter
    |> build_assoc(:submissions)
    |> Submission.changeset(changes)
    |> Repo.insert!()
  end
end
