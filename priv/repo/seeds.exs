# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs

alias Callforpapers.User
alias Callforpapers.Submission
alias Callforpapers.Repo
[
  %{name: "Bratislav Metulski", email: "brasis@lav.se", bio: "None of your business", picture: "", password: "12345678", role: "presenter"},
  %{name: "Hugo Organizer", email: "hugo@organize.de", bio: "None of your business", picture: "", password: "12345678", role: "organizer"}
]
|> Enum.each(fn user ->
  Repo.get_by(User, email: user.email)
  || Repo.insert!(User.registration_changeset(%User{}, user))
end)

