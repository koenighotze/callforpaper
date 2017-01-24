defmodule Callforpapers.PresenterController do
  use Callforpapers.Web, :controller
  alias Callforpapers.Presenter

  plug :authenticate_user when action in [:index, :show, :edit, :update, :delete]


  def index(conn, _params) do
    presenters = Repo.all(Presenter)
    render(conn, "index.html", presenters: presenters)
  end

  def new(conn, _params) do
    changeset = Presenter.changeset(%Presenter{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"presenter" => presenter_params}) do
    changeset = Presenter.registration_changeset(%Presenter{}, presenter_params)

    case Repo.insert(changeset) do
      {:ok, _presenter} ->
        conn
        |> put_flash(:info, "Presenter created successfully.")
        |> redirect(to: presenter_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    presenter = Repo.get!(Presenter, id)
    render(conn, "show.html", presenter: presenter)
  end

  def edit(conn, %{"id" => id}) do
    presenter = Repo.get!(Presenter, id)
    changeset = Presenter.changeset(presenter)
    render(conn, "edit.html", presenter: presenter, changeset: changeset)
  end

  def update(conn, %{"id" => id, "presenter" => presenter_params}) do
    presenter = Repo.get!(Presenter, id)
    changeset = Presenter.changeset(presenter, presenter_params)

    case Repo.update(changeset) do
      {:ok, presenter} ->
        conn
        |> put_flash(:info, "Presenter updated successfully.")
        |> redirect(to: presenter_path(conn, :show, presenter))
      {:error, changeset} ->
        render(conn, "edit.html", presenter: presenter, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    presenter = Repo.get!(Presenter, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(presenter)

    conn
    |> put_flash(:info, "Presenter deleted successfully.")
    |> redirect(to: presenter_path(conn, :index))
  end
end
