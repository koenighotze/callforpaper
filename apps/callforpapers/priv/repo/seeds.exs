# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs

alias Callforpapers.Presenter
alias Callforpapers.Submission
alias Callforpapers.Repo
[
  %Presenter{name: "Bratislav Metulski", email: "brasis@lav.se", bio: "None of your business", picture: "", password: "12345678"}
]
|> Enum.each(fn presenter ->
  Repo.get_by(Presenter, email: presenter.email)
  || Repo.insert!(presenter)
end)

