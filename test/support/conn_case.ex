defmodule Callforpapers.ConnCase do
  import Callforpapers.TestHelpers, only: [insert_presenter: 1, insert_organizer: 1]

  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build and query models.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """



  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest

      alias Callforpapers.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import Callforpapers.Router.Helpers

      import Callforpapers.TestHelpers

      # The default endpoint for testing
      @endpoint Callforpapers.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Callforpapers.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Callforpapers.Repo, {:shared, self()})
    end

    conn = Phoenix.ConnTest.build_conn()

    if loginname = tags[:login_as] do
      user = Callforpapers.Repo.get_by(Callforpapers.Presenter, name: loginname)
             || if tags[:as_organizer], do: insert_organizer(name: loginname), else: insert_presenter(name: loginname)
      conn = Plug.Conn.assign(conn, :current_user, user)

      {:ok, conn: conn, user: user}
    else
      {:ok, conn: conn}
    end
  end
end
