defmodule Callforpapers.SubmissionController do
  use Callforpapers.Web, :controller
  import Logger
  alias Callforpapers.Submission
  alias Callforpapers.Presenter

  plug :authenticate_user
  plug :load_presenters when action in [:create, :update, :new, :edit]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def load_presenters(conn, _opts) do
    presenters = Presenter
           |> Presenter.alphabetical
           |> Presenter.names_and_ids
           |> Repo.all

    conn
    |> assign(:presenters, presenters)
  end

  def index(conn, _params, current_user) do
    submissions =
      current_user
      |> Presenter.submissions_by_presenter
      |> Repo.all
    render(conn, "index.html", submissions: submissions)
  end

  def new(conn, _params, current_user) do
    changeset = Submission.changeset(%Submission{})

    conn =
      conn
      |> assign(:durations, [20, 45, 60, 90])

    render conn, "new.html", presenters: conn.assigns[:presenters], changeset: changeset
  end

  def create(conn, %{"submission" => submission_params}, current_user) do
    changeset =
      current_user
      |> build_assoc(:submissions)
      |> Submission.changeset(submission_params)

    case Repo.insert(changeset) do
      {:ok, _submission} ->
        conn
        |> put_flash(:info, "Submission created successfully.")
        |> redirect(to: submission_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp submission_by_id(current_user, id) do
    current_user
      |> Presenter.submissions_by_presenter
      |> Repo.get!(id)
  end

  def show(conn, %{"id" => id}, current_user) do
    submission = submission_by_id(current_user, id)
      # current_user
      # |> Presenter.submissions_by_presenter
      # |> Repo.get!(id)

    render(conn, "show.html", submission: submission)
  end

  def edit(conn, %{"id" => id}, current_user) do
    submission = submission_by_id(current_user, id)
      # current_user
      # |> Presenter.submissions_by_presenter
      # |> Repo.get!(id)
    changeset = Submission.changeset(submission)
    render(conn, "edit.html", submission: submission, changeset: changeset)
  end

  def update(conn, %{"id" => id, "submission" => submission_params}, current_user) do
    submission = submission_by_id(current_user, id)
      # current_user
      # |> Presenter.submissions_by_presenter
      # |> Repo.get!(id)
    changeset = Submission.changeset(submission, submission_params)

    case Repo.update(changeset) do
      {:ok, submission} ->
        conn
        |> put_flash(:info, "Submission updated successfully.")
        |> redirect(to: submission_path(conn, :show, submission))
      {:error, changeset} ->
        render(conn, "edit.html", submission: submission, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    submission = submission_by_id(current_user, id)
      # current_user
      # |> Presenter.submissions_by_presenter
      # |> Repo.get!(id)

    Repo.delete!(submission)

    conn
    |> put_flash(:info, "Submission deleted successfully.")
    |> redirect(to: submission_path(conn, :index))
  end
end
