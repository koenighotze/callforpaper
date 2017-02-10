defmodule Callforpapers.SubmissionController do
  use Callforpapers.Web, :controller

  alias Callforpapers.Submission
  alias Callforpapers.Cfp
  alias Callforpapers.User
  alias Callforpapers.Talk
  import Callforpapers.Auth, only: [ presenter_only: 2 ]

  plug :presenter_only when action in [:create, :update, :new, :edit, :delete]

  plug :load_callforpapers when action in [:create, :update, :new, :edit]
  plug :load_submissions when action in [:create, :update, :new, :edit]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def load_callforpapers(conn, _params) do
    cfps = Cfp
           |> Cfp.with_conference
           |> Cfp.only_open
           |> Repo.all
           |> Enum.map( fn cfp -> {cfp.conference.title, cfp.id} end)

    conn
    |> assign(:callforpapers, cfps)
  end

  # todo refactor me
  def load_submissions(conn, _params) do
    talks =
      conn.assigns.current_user
      |> User.talks_by_presenter
      |> Talk.title_and_id
      |> Repo.all

    conn
    |> assign(:talks, talks)
  end

  def accept(conn, %{"submission_id" => submission_id}, _current_user) do
    submission =
      Repo.get(Submission, submission_id)
      |> Submission.accept
      |> Repo.update!

    redirect(conn, to: callforpapers_path(conn, :show, submission.cfp_id))
  end

  def reject(conn, %{"submission_id" => submission_id}, _current_user) do
    submission =
      Repo.get(Submission, submission_id)
      |> Submission.reject
      |> Repo.update!

    redirect(conn, to: callforpapers_path(conn, :show, submission.cfp_id))
  end

  def index(conn, _params, current_user) do
    submissions = Submission |> Submission.with_cfp |> Submission.with_talk |> Repo.all |> Enum.filter(fn f -> f.submission.user.id == current_user.id end)
    render(conn, "index.html", submissions: submissions)
  end

  def new(conn, _params, _current_user) do
    changeset = Submission.changeset(%Submission{})

    render(conn, "new.html", changeset: changeset, talks: conn.assigns.talks, callforpapers: conn.assigns.callforpapers)
  end

  def create(conn, %{"submission" => submission_params}, _current_user) do
    changeset = Submission.changeset(%Submission{}, submission_params)

    case Repo.insert(changeset) do
      {:ok, _submission} ->
        conn
        |> put_flash(:info, "Talk submitted successfully.")
        |> redirect(to: submission_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, talks: conn.assigns.talks, callforpapers: conn.assigns.callforpapers)
    end
  end

  def show(conn, %{"id" => id}, _current_user) do
    submission = Repo.get!(Submission, id)
    render(conn, "show.html", submission: submission)
  end

  def edit(conn, %{"id" => id}, _current_user) do
    submission = Repo.get!(Submission, id)
    changeset = Submission.changeset(submission)
    render(conn, "edit.html", submission: submission, changeset: changeset, talks: conn.assigns.talks, callforpapers: conn.assigns.callforpapers)
  end

  def update(conn, %{"id" => id, "submission" => params}, _current_user) do
    submission = Repo.get!(Submission, id)
    changeset = Submission.changeset(submission, params)

    case Repo.update(changeset) do
      {:ok, submission} ->
        conn
        |> put_flash(:info, "Submission updated successfully.")
        |> redirect(to: submission_path(conn, :show, submission))
      {:error, changeset} ->
        render(conn, "edit.html", submission: submission, changeset: changeset, talks: conn.assigns.talks, callforpapers: conn.assigns.callforpapers)
    end
  end

  def delete(conn, %{"id" => id}, _current_user) do
    submission = Repo.get!(Submission, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(submission)

    conn
    |> put_flash(:info, "Submission deleted successfully.")
    |> redirect(to: submission_path(conn, :index))
  end
end
