defmodule Mix.Tasks.Fixtures do
  defmodule Gen do
    use Mix.Task

    alias ShowsStore.Schemas.{Show, Venue, Band}

    @shortdoc "Generate fixtures."

    @impl Mix.Task
    def run(_) do
      Mix.Task.run("run")
      ShowsStore.insert_show(show1())
      ShowsStore.insert_show(show2())
      ShowsStore.insert_show(show3())
    end

    defp show1,
      do: %Show{
        date: DateTime.from_naive!(~N[2019-11-20 18:30:00], "Etc/UTC"),
        price: 20.5,
        link: "http://lebikini.com/aether_realm-summoning",
        venue: le_bikini(),
        bands: [aether_realm(), summoning()]
      }

    defp show2,
      do: %Show{
        date: DateTime.from_naive!(~N[2019-11-23 20:00:00], "Etc/UTC"),
        price: 18.45,
        link: "http://leferrailleur.fr/aether_realm-cardiac",
        venue: le_ferailleur(),
        bands: [aether_realm(), cardiac()]
      }

    defp show3,
      do: %Show{
        date: DateTime.from_naive!(~N[2019-11-27 19:00:00], "Etc/UTC"),
        price: 31.5,
        link: "http://leferrailleur.fr/aether_realm-cardiac-summoning",
        venue: le_ferailleur(),
        bands: [aether_realm(), cardiac(), summoning()]
      }

    defp le_bikini,
      do: %Venue{
        name: "Le Bikini",
        website: "http://lebikini.com",
        city: "Ramonville St Agne",
        zip_code: "31520"
      }

    defp le_ferailleur,
      do: %Venue{
        name: "Le Ferailleur",
        website: "http://leferrailleur.fr/",
        city: "Nantes",
        zip_code: "44000"
      }

    defp aether_realm,
      do: %Band{
        name: "Aether Realm",
        website: "https://aether-realm.bandcamp.com/",
        country: "USA",
        genres: ["melodic death metal", "wintersun"]
      }

    defp summoning,
      do: %Band{
        name: "Summoning",
        website: "https://summoning.bandcamp.com/",
        country: "Austria",
        genres: ["black metal", "atmospheric black metal"]
      }

    defp cardiac,
      do: %Band{
        name: "Cardiac",
        website: "https://cardiacofficialpage.bandcamp.com/",
        country: "Switzerland",
        genres: ["hardcore"]
      }
  end
end
