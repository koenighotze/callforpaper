defmodule Callforpapers.SessionController do
  use Callforpapers.Web, :controller

  alias Callforpapers.Repo
  alias Callforpapers.Auth

  plug :authenticate_user when action in [:delete]

  def new(conn, _params) do
    render conn, "login.html"
  end

  def create(conn, %{"session" => %{ "username" => uid, "password" => passwd }  }) do
    case Auth.login_by_username_and_password(conn, uid, passwd, repo: Repo) do
      {:ok, conn} -> conn
                     |> put_flash(:info, "Welcome back!")
                     |> redirect(to: page_path(conn, :index))
      _ -> conn
           |> put_flash(:error, "Cannot login!")
           |> render("login.html")
    end

    render conn, "login.html"
  end

  def delete(conn, _params) do
    conn
    |> Auth.logout
    |> redirect(to: page_path(conn, :index))
  end

end
