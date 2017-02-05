defmodule Callforpapers.FilingController do
  use Callforpapers.Web, :controller

  alias Callforpapers.Filing
  alias Callforpapers.Cfp
  alias Callforpapers.User
  alias Callforpapers.Submission

  plug :load_callforpapers when action in [:create, :update, :new, :edit]
  plug :load_submissions when action in [:create, :update, :new, :edit]

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
    submissions =
      conn.assigns.current_user
      |> User.submissions_by_presenter
      |> Submission.title_and_id
      |> Repo.all

    conn
    |> assign(:submissions, submissions)
  end

  def index(conn, _params) do
    filings = Filing |> Filing.with_cfp |> Filing.with_submission |> Repo.all
    render(conn, "index.html", filings: filings)
  end

  def new(conn, _params) do
    changeset = Filing.changeset(%Filing{})

    render(conn, "new.html", changeset: changeset, submissions: conn.assigns.submissions, callforpapers: conn.assigns.callforpapers)
  end

  def create(conn, %{"filing" => filing_params}) do
    changeset = Filing.changeset(%Filing{}, filing_params)

    case Repo.insert(changeset) do
      {:ok, _filing} ->
        conn
        |> put_flash(:info, "Filing created successfully.")
        |> redirect(to: filing_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    filing = Repo.get!(Filing, id)
    render(conn, "show.html", filing: filing)
  end

  def edit(conn, %{"id" => id}) do
    filing = Repo.get!(Filing, id)
    changeset = Filing.changeset(filing)
    render(conn, "edit.html", filing: filing, changeset: changeset, submissions: conn.assigns.submissions, callforpapers: conn.assigns.callforpapers)
  end

  def update(conn, %{"id" => id, "filing" => filing_params}) do
    filing = Repo.get!(Filing, id)
    changeset = Filing.changeset(filing, filing_params)

    case Repo.update(changeset) do
      {:ok, filing} ->
        conn
        |> put_flash(:info, "Filing updated successfully.")
        |> redirect(to: filing_path(conn, :show, filing))
      {:error, changeset} ->
        render(conn, "edit.html", filing: filing, changeset: changeset, submissions: conn.assigns.submissions, callforpapers: conn.assigns.callforpapers)
    end
  end

  def delete(conn, %{"id" => id}) do
    filing = Repo.get!(Filing, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(filing)

    conn
    |> put_flash(:info, "Filing deleted successfully.")
    |> redirect(to: filing_path(conn, :index))
  end
end
