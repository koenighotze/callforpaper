defmodule Callforpapers.CallforpapersController do
  use Callforpapers.Web, :controller

  alias Callforpapers.Cfp
  alias Callforpapers.Conference

  plug :load_conferences when action in [:create, :update, :new, :edit]

  def load_conferences(conn, _params) do
    conferences = Conference
           |> Conference.titles_and_ids
           |> Conference.filter_on_organizer(conn.assigns.current_user)
           |> Repo.all

    conn
    |> assign(:conferences, conferences)
  end

  def index(conn, _params) do
    callforpapers = Cfp |> Cfp.with_conference |> Repo.all
    render(conn, "index.html", callforpapers: callforpapers)
  end

  def new(conn, _params) do
    changeset =
        %Conference{}
        |> build_assoc(:callforpapers)
        |> Cfp.changeset(%{status: "open"})

    render(conn, "new.html", changeset: changeset, cfp_stati: Cfp.valid_stati)
  end

  def create(conn, %{"cfp" => callforpapers_params}) do
    changeset =
        Repo.get(Conference, callforpapers_params["conference_id"])
        |> build_assoc(:callforpapers)
        |> Cfp.changeset(callforpapers_params)

    case Repo.insert(changeset) do
      {:ok, _callforpapers} ->
        conn
        |> put_flash(:info, "Callforpapers created successfully.")
        |> redirect(to: callforpapers_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, cfp_stati: Cfp.valid_stati)
    end
  end

  def show(conn, %{"id" => id}) do
    callforpapers = Repo.get!(Cfp |> Cfp.with_conference, id)
    render(conn, "show.html", cfp: callforpapers)
  end

  def edit(conn, %{"id" => id}) do
    callforpapers = Repo.get!(Cfp, id)
    changeset = Cfp.changeset(callforpapers)
    render(conn, "edit.html", cfp: callforpapers, changeset: changeset, cfp_stati: Cfp.valid_stati)
  end

  def update(conn, %{"id" => id, "cfp" => callforpapers_params}) do
    callforpapers = Repo.get!(Cfp, id)
    changeset = Cfp.changeset(callforpapers, callforpapers_params)

    case Repo.update(changeset) do
      {:ok, callforpapers} ->
        conn
        |> put_flash(:info, "Callforpapers updated successfully.")
        |> redirect(to: callforpapers_path(conn, :show, callforpapers))
      {:error, changeset} ->
        render(conn, "edit.html", cfp: callforpapers, changeset: changeset, cfp_stati: Cfp.valid_stati)
    end
  end

  def delete(conn, %{"id" => id}) do
    callforpapers = Repo.get!(Cfp, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(callforpapers)

    conn
    |> put_flash(:info, "Callforpapers deleted successfully.")
    |> redirect(to: callforpapers_path(conn, :index))
  end
end