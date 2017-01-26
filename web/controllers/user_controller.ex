defmodule Callforpapers.UserController do
  use Callforpapers.Web, :controller
  import Callforpapers.User, only: [is_organizer?: 1]
  alias Callforpapers.User

  import Logger

  plug :authenticate_user when action in [:index, :show, :edit, :update, :delete]
  plug :authenticate_organizer when action in [:index, :show, :edit, :update, :delete]

  def authenticate_organizer(conn, _opts) do
    user = conn.assigns.current_user

    cond do
      is_organizer?(user) -> conn
      conn.params["id"] == "#{user.id}" -> conn
      true -> conn
              |> put_status(:not_found)
              |> render(Callforpapers.ErrorView, "404.html")
              |> Plug.Conn.halt()
    end
  end

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => params}) do
    changeset = User.registration_changeset(%User{}, params)

    info("Creating changeset #{inspect changeset}")
    case Repo.insert(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    # current_user = conn.assigns.current_user
    user = Repo.get!(User, id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => params}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, params)

    case Repo.update(changeset) do
      {:ok, updated} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, updated))
      {:error, changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)
    next_page = if is_organizer?(conn.assigns.current_user), do: user_path(conn, :index), else: page_path(conn, :index)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: next_page)
  end
end
