defmodule CfpUi.PresentationController do
  use CfpUi.Web, :controller

  alias CfpUi.Presentation

  def index(conn, _params) do
    presentations = Repo.all(Presentation)
    render(conn, "index.html", presentations: presentations)
  end

  def new(conn, _params) do
    changeset = Presentation.changeset(%Presentation{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"presentation" => presentation_params}) do
    changeset = Presentation.changeset(%Presentation{}, presentation_params)

    case Repo.insert(changeset) do
      {:ok, _presentation} ->
        conn
        |> put_flash(:info, "Presentation created successfully.")
        |> redirect(to: presentation_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    presentation = Repo.get!(Presentation, id)
    render(conn, "show.html", presentation: presentation)
  end

  def edit(conn, %{"id" => id}) do
    presentation = Repo.get!(Presentation, id)
    changeset = Presentation.changeset(presentation)
    render(conn, "edit.html", presentation: presentation, changeset: changeset)
  end

  def update(conn, %{"id" => id, "presentation" => presentation_params}) do
    presentation = Repo.get!(Presentation, id)
    changeset = Presentation.changeset(presentation, presentation_params)

    case Repo.update(changeset) do
      {:ok, presentation} ->
        conn
        |> put_flash(:info, "Presentation updated successfully.")
        |> redirect(to: presentation_path(conn, :show, presentation))
      {:error, changeset} ->
        render(conn, "edit.html", presentation: presentation, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    presentation = Repo.get!(Presentation, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(presentation)

    conn
    |> put_flash(:info, "Presentation deleted successfully.")
    |> redirect(to: presentation_path(conn, :index))
  end
end
