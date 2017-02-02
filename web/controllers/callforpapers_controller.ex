defmodule Callforpapers.CallforpapersController do
  use Callforpapers.Web, :controller

  alias Callforpapers.Callforpapers, as: Cfp
  alias Callforpapers.Conferences



  def load_conferences(conn, _params) do
    conferences = Callforpapers.Conferences
           |> Cfp.titles_and_ids
           |> Cfp.filter_on_organizer
           |> Repo.all

    conn
    |> assign(:conferences, conferences)
  end

  def index(conn, _params) do
    callforpapers = Repo.all(Cfp)
    render(conn, "index.html", callforpapers: callforpapers)
  end

  def new(conn, _params) do
    changeset = Cfp.changeset(%Cfp{})
    render(conn, "new.html", changeset: changeset, cfp_stati: Cfp.valid_stati)
  end

  def create(conn, %{"callforpapers" => callforpapers_params}) do
    changeset = Cfp.changeset(%Cfp{}, callforpapers_params)

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
    callforpapers = Repo.get!(Cfp, id)
    render(conn, "show.html", callforpapers: callforpapers)
  end

  def edit(conn, %{"id" => id}) do
    callforpapers = Repo.get!(Cfp, id)
    changeset = Cfp.changeset(callforpapers)
    render(conn, "edit.html", callforpapers: callforpapers, changeset: changeset, cfp_stati: Cfp.valid_stati)
  end

  def update(conn, %{"id" => id, "callforpapers" => callforpapers_params}) do
    callforpapers = Repo.get!(Cfp, id)
    changeset = Cfp.changeset(callforpapers, callforpapers_params)

    case Repo.update(changeset) do
      {:ok, callforpapers} ->
        conn
        |> put_flash(:info, "Callforpapers updated successfully.")
        |> redirect(to: callforpapers_path(conn, :show, callforpapers))
      {:error, changeset} ->
        render(conn, "edit.html", callforpapers: callforpapers, changeset: changeset, cfp_stati: Cfp.valid_stati)
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
