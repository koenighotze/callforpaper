defmodule Callforpapers.ConferenceController do
  use Callforpapers.Web, :controller

  alias Callforpapers.Conference
  alias Callforpapers.Cfp
  alias Callforpapers.Submission

  plug :load_accepted_talks when action in [ :show ]

  def load_accepted_talks(conn, _param) do
    %{params: %{"id" => conference_id}} = conn
    # todo: refactor me
    all_cfp_ids = Repo.all(from c in Cfp, where: c.conference_id == ^conference_id, select: c.id)

    talks = Repo.all(from s in Submission,
                           preload: [{:submission, :user}],
                           where: s.status == "accepted" and s.cfp_id in ^all_cfp_ids)
            |> Enum.map(fn s ->
              %{
                title: s.submission.title,
                presenter: s.submission.user.name,
                shortsummary: s.submission.shortsummary,
                duration: s.submission.duration,
                externallink: s.submission.externallink,
              }
            end)

    conn
    |> assign(:accepted_talks, talks)
  end

  def index(conn, _params) do
    conferences = Repo.all(Conference)
    render(conn, "index.html", conferences: conferences)
  end

  def new(conn, _params) do
    changeset = Conference.changeset(%Conference{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"conference" => conference_params}) do
    changeset = Conference.changeset(%Conference{}, conference_params)

    case Repo.insert(changeset) do
      {:ok, _conference} ->
        conn
        |> put_flash(:info, "Conference created successfully.")
        |> redirect(to: conference_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    conference = Repo.get!(Conference, id)
    render(conn, "show.html", conference: conference, accepted_talks: conn.assigns.accepted_talks)
  end

  def edit(conn, %{"id" => id}) do
    conference = Repo.get!(Conference, id)
    changeset = Conference.changeset(conference)
    render(conn, "edit.html", conference: conference, changeset: changeset)
  end

  def update(conn, %{"id" => id, "conference" => conference_params}) do
    conference = Repo.get!(Conference, id)
    changeset = Conference.changeset(conference, conference_params)

    case Repo.update(changeset) do
      {:ok, conference} ->
        conn
        |> put_flash(:info, "Conference updated successfully.")
        |> redirect(to: conference_path(conn, :show, conference))
      {:error, changeset} ->
        render(conn, "edit.html", conference: conference, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    conference = Repo.get!(Conference, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(conference)

    conn
    |> put_flash(:info, "Conference deleted successfully.")
    |> redirect(to: conference_path(conn, :index))
  end
end
