defmodule Callforpapers.FilingController do
  use Callforpapers.Web, :controller

  alias Callforpapers.Filing
  alias Callforpapers.Cfp
  alias Callforpapers.User
  alias Callforpapers.Talk, as: Submission

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
    submissions =
      conn.assigns.current_user
      |> User.submissions_by_presenter
      |> Submission.title_and_id
      |> Repo.all

    conn
    |> assign(:submissions, submissions)
  end

  def accept(conn, %{"filing_id" => filing_id}, _current_user) do
    filing =
      Repo.get(Filing, filing_id)
      |> Filing.accept
      |> Repo.update!

    redirect(conn, to: callforpapers_path(conn, :show, filing.cfp_id))
  end

  def reject(conn, %{"filing_id" => filing_id}, _current_user) do
    filing =
      Repo.get(Filing, filing_id)
      |> Filing.reject
      |> Repo.update!

    redirect(conn, to: callforpapers_path(conn, :show, filing.cfp_id))
  end

  def index(conn, _params, current_user) do
    filings = Filing |> Filing.with_cfp |> Filing.with_submission |> Repo.all |> Enum.filter(fn f -> f.submission.user.id == current_user.id end)
    render(conn, "index.html", filings: filings)
  end

  def new(conn, _params, _current_user) do
    changeset = Filing.changeset(%Filing{})

    render(conn, "new.html", changeset: changeset, submissions: conn.assigns.submissions, callforpapers: conn.assigns.callforpapers)
  end

  def create(conn, %{"filing" => filing_params}, _current_user) do
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

  def show(conn, %{"id" => id}, _current_user) do
    filing = Repo.get!(Filing, id)
    render(conn, "show.html", filing: filing)
  end

  def edit(conn, %{"id" => id}, _current_user) do
    filing = Repo.get!(Filing, id)
    changeset = Filing.changeset(filing)
    render(conn, "edit.html", filing: filing, changeset: changeset, submissions: conn.assigns.submissions, callforpapers: conn.assigns.callforpapers)
  end

  def update(conn, %{"id" => id, "filing" => filing_params}, _current_user) do
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

  def delete(conn, %{"id" => id}, _current_user) do
    filing = Repo.get!(Filing, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(filing)

    conn
    |> put_flash(:info, "Filing deleted successfully.")
    |> redirect(to: filing_path(conn, :index))
  end
end
