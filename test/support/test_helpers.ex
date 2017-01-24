defmodule Callforpapers.TestHelpers do
  import Ecto.Query

  alias Callforpapers.Repo
  alias Callforpapers.Presenter

  @default_presenter %{name: "Bratislav Metulski", email: "brasis@lav.se", bio: "None of your business", picture: "", password: "12345678"}

  def insert_presenter(attrs \\ %{}) do
    changes = Dict.merge(@default_presenter, attrs)

    %Presenter{}
    |> Presenter.registration_changeset(changes)
    |> Repo.insert!()
  end
end
