defmodule Callforpapers.SubmissionController do
  use Callforpapers.Web, :controller

  import Logger
  alias Callforpapers.Submission
  alias Callforpapers.Presenter

  plug :load_presenters when action in [:create, :update, :new, :edit]

  def load_presenters(conn, _opts) do
    presenters = Presenter
           |> Presenter.alphabetical
           |> Presenter.names_and_ids
           |> Repo.all

    conn
    |> assign(:presenters, presenters)
  end

  def index(conn, _params) do
    submissions = Repo.all(Submission)
    render(conn, "index.html", submissions: submissions)
  end

  def new(conn, _params) do
    changeset = Submission.changeset(%Submission{})

    conn =
      conn
      |> assign(:durations, [20, 45, 60, 90])

    render conn, "new.html", presenters: conn.assigns[:presenters], changeset: changeset
  end

  def create(conn, %{"submission" => submission_params}) do
    changeset = Submission.changeset(%Submission{}, submission_params)

    case Repo.insert(changeset) do
      {:ok, _submission} ->
        conn
        |> put_flash(:info, "Submission created successfully.")
        |> redirect(to: submission_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    submission = Repo.get!(Submission, id)
    render(conn, "show.html", submission: submission)
  end

  def edit(conn, %{"id" => id}) do
    submission = Repo.get!(Submission, id)
    changeset = Submission.changeset(submission)
    render(conn, "edit.html", submission: submission, changeset: changeset)
  end

  def update(conn, %{"id" => id, "submission" => submission_params}) do
    submission = Repo.get!(Submission, id)
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

  def delete(conn, %{"id" => id}) do
    submission = Repo.get!(Submission, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(submission)

    conn
    |> put_flash(:info, "Submission deleted successfully.")
    |> redirect(to: submission_path(conn, :index))
  end
end
