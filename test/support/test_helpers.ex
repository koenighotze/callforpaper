defmodule Callforpapers.TestHelpers do
  import Ecto
  alias Callforpapers.Repo
  alias Callforpapers.User
  alias Callforpapers.Talk
  alias Callforpapers.Submission
  alias Callforpapers.Conference
  alias Callforpapers.Cfp

  @default_presenter %{name: "Bratislav Metulski", email: "brasis@lav.se", bio: "None of your business", picture: "", password: "12345678", role: "presenter"}
  @default_submission %{duration: 42, shortsummary: "some cadsasddasadsadsadsdasadsadsontent", title: "some content"}
  @default_conference %{end: %{day: 17, month: 4, year: 2010}, start: %{day: 17, month: 3, year: 2010}, title: "some title"}
  @default_cfp %{end: %{day: 17, month: 4, year: 2010}, start: %{day: 17, month: 3, year: 2010}, status: "open"}

  def insert_organizer(attrs \\ %{}) do
    insert_presenter(Dict.merge(attrs, %{role: "organizer"}))
  end

  def insert_presenter(attrs \\ %{}) do
    changes = Dict.merge(@default_presenter, attrs)

    %User{}
    |> User.registration_changeset(changes)
    |> Repo.insert!()
  end

  def insert_submission(presenter, attrs \\ %{}), do: insert_talk(presenter, attrs)

  def insert_talk(presenter, attrs \\ %{}) do
    changes = Dict.merge(@default_submission, attrs)
    presenter
    |> build_assoc(:talks)
    |> Talk.changeset(changes)
    |> Repo.insert!()
  end

  def insert_conference(organizer, attrs \\ %{}) do
    changes = Dict.merge(@default_conference, attrs)

    organizer
    |> build_assoc(:conferences)
    |> Conference.changeset(changes)
    |> Repo.insert!()
  end

  def insert_cfp(conf, attrs \\ %{}) do
    changes = Dict.merge(@default_cfp, attrs)

    conf
    |> build_assoc(:callforpapers)
    |> Cfp.changeset(changes)
    |> Repo.insert!()
  end

  def submit_talk(talk, cfp) do
    Repo.insert! %Submission{talk_id: talk.id, cfp_id: cfp.id}
  end

  def insert_filing(organizer, presenter \\ nil) do
    presenter = presenter || insert_presenter
    submission = insert_submission(presenter)
    callforpapers = organizer |> insert_conference |> insert_cfp
    Repo.insert! %Submission{talk_id: submission.id, cfp_id: callforpapers.id}
  end
end
