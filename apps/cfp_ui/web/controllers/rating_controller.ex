defmodule CfpUi.RatingController do
  use CfpUi.Web, :controller

  alias CfpUi.Rating

  def index(conn, _params) do
    ratings = Repo.all(Rating)
    render(conn, "index.html", ratings: ratings)
  end

  def new(conn, _params) do
    changeset = Rating.changeset(%Rating{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"rating" => rating_params}) do
    changeset = Rating.changeset(%Rating{}, rating_params)

    case Repo.insert(changeset) do
      {:ok, _rating} ->
        conn
        |> put_flash(:info, "Rating created successfully.")
        |> redirect(to: rating_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    rating = Repo.get!(Rating, id)
    render(conn, "show.html", rating: rating)
  end

  def edit(conn, %{"id" => id}) do
    rating = Repo.get!(Rating, id)
    changeset = Rating.changeset(rating)
    render(conn, "edit.html", rating: rating, changeset: changeset)
  end

  def update(conn, %{"id" => id, "rating" => rating_params}) do
    rating = Repo.get!(Rating, id)
    changeset = Rating.changeset(rating, rating_params)

    case Repo.update(changeset) do
      {:ok, rating} ->
        conn
        |> put_flash(:info, "Rating updated successfully.")
        |> redirect(to: rating_path(conn, :show, rating))
      {:error, changeset} ->
        render(conn, "edit.html", rating: rating, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    rating = Repo.get!(Rating, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(rating)

    conn
    |> put_flash(:info, "Rating deleted successfully.")
    |> redirect(to: rating_path(conn, :index))
  end
end
