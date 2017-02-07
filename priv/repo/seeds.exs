# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs

alias Callforpapers.User
alias Callforpapers.Talk
alias Callforpapers.Conference
alias Callforpapers.Repo

import Ecto, only: [build_assoc: 2]
[
  %{name: "Bratislav Metulski", email: "brasis@lav.se", bio: "None of your business", picture: "", password: "12345678", role: "presenter"},
  %{name: "Hugo Organizer", email: "hugo@organize.de", bio: "None of your business", picture: "", password: "12345678", role: "organizer"}
]
|> Enum.each(fn user ->
  Repo.get_by(User, email: user.email)
  || Repo.insert!(User.registration_changeset(%User{}, user))
end)

organizer = Repo.get_by(User, email: "hugo@organize.de")
[
  %{title: "Extreme Agile Digital Experience", start: ~D{2016-08-01}, end: ~D{2016-08-12}},
  %{title: "DevCon Summer Camp", start: ~D{2017-05-01}, end: ~D{2017-05-12}}
]
|> Enum.each(fn conf ->
  Repo.get_by(Conference, title: conf.title)
  || organizer
     |> build_assoc(:conferences)
     |> Conference.changeset(conf)
     |> Repo.insert!
end)

presenter = Repo.get_by(User, email: "brasis@lav.se")
conference = Repo.get_by(Conference, title: "Extreme Agile Digital Experience")

# todo add call for paper
# todo file paper

