defmodule ShowsStore.Fixtures do
  alias ShowsStore.Schemas.{Show, Venue, Band}

  def gen() do
    le_bikini = %Venue{
      name: "Le Bikini",
      website: "http://lebikini.com",
      city: "Ramonville St Agne",
      zip_code: "31520"
    }

    le_ferailleur = %Venue{
      name: "Le Ferailleur",
      website: "http://leferrailleur.fr/",
      city: "Nantes",
      zip_code: "44000"
    }

    aether_realm = %Band{
      name: "Aether Realm",
      website: "https://aether-realm.bandcamp.com/",
      country: "USA",
      genres: ["melodic death metal", "wintersun"]
    }

    summoning = %Band{
      name: "Summoning",
      website: "https://summoning.bandcamp.com/",
      country: "Austria",
      genres: ["black metal", "atmospheric black metal"]
    }

    cardiac = %Band{
      name: "Cardiac",
      website: "https://cardiacofficialpage.bandcamp.com/",
      country: "Switzerland",
      genres: ["hardcore"]
    }

    show1 = %Show{
      date: DateTime.from_naive!(~N[2019-11-20 18:30:00], "Etc/UTC"),
      price: 20.5,
      link: "http://lebikini.com/aether_realm-summoning",
      venue: le_bikini,
      bands: [aether_realm, summoning]
    }

    show2 = %Show{
      date: DateTime.from_naive!(~N[2019-11-23 20:00:00], "Etc/UTC"),
      price: 18.45,
      link: "http://leferrailleur.fr/aether_realm-cardiac",
      venue: le_ferailleur,
      bands: [aether_realm, cardiac]
    }

    show3 = %Show{
      date: DateTime.from_naive!(~N[2019-11-27 19:00:00], "Etc/UTC"),
      price: 31.5,
      link: "http://leferrailleur.fr/aether_realm-cardiac-summoning",
      venue: le_ferailleur,
      bands: [aether_realm, cardiac, summoning]
    }

    ShowsStore.insert_show(show1)
    ShowsStore.insert_show(show2)
    ShowsStore.insert_show(show3)
  end
end
