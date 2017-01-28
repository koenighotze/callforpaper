defmodule Callforpapers.Auth do
  import Plug.Conn

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  import Phoenix.Controller
  import Logger
  alias Callforpapers.User
  alias Callforpapers.Router.Helpers

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)
    cond do
      user = conn.assigns[:current_user]
           -> put_current_user(conn, user)
      user = user_id && repo.get(User, user_id)
           -> put_current_user(conn, user)
      true -> assign(conn, :current_user, nil)
    end
  end

  def login(conn, user) do
    info("Logging in")
    conn
    |> put_current_user(user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def put_current_user(conn, user) do
    # token = Phoenix.Token.sign(conn, @salt, user.id)

    # debug("Assigning token #{token} to user #{user.id}")

    conn = conn
    |> assign(:current_user, user)
    # |> assign(:user_token, token)

    debug("Assigns are #{inspect conn.assigns}")

    conn
  end

  def logout(conn) do
    info("Logging out")
    configure_session(conn, drop: true)
  end

  def login_by_username_and_password(conn, email, passwd, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(Callforpapers.User, email: email)

    cond do
      user && checkpw(passwd, user.password_hash)
           -> {:ok, login(conn, user)}
      user -> {:error, :unauthorized, conn}
      true -> dummy_checkpw()
              {:error, :not_found, conn}
    end
  end

  def authenticate_user(conn, _opts) do
    # Todo: think of a smarter way... maybe check for the key or something
    case conn.assigns.current_user do
      nil -> conn
             |> put_flash(:error, "Please log in first")
             |> redirect(to: Helpers.page_path(conn, :index))
             |> halt()
      _ -> conn
    end
  end

  def authenticate_organizer(conn, _opts) do
    user = conn.assigns.current_user

    cond do
      User.is_organizer?(user) -> conn
      conn.params["id"] == "#{user.id}" -> conn
      true -> conn
              |> put_status(:not_found)
              |> render(Callforpapers.ErrorView, "404.html")
              |> Plug.Conn.halt()
    end
  end
end
