defmodule LeFerrailleurTest do
  use ExUnit.Case

  test "scrap" do
    [event1, event2, event3] = Scrapers.LeFerrailleur.scrap()

    le_ferrailleur = %ShowsStore.Schemas.Venue{
      name: "Le Ferrailleur",
      website: "http://leferrailleur.fr",
      city: "Nantes",
      zip_code: "44000"
    }

    assert event1 == %ShowsStore.Schemas.Show{
             date: nil,
             price: nil,
             link: "http://leferrailleur.fr/evenement/catfish/3281",
             venue: le_ferrailleur,
             bands: []
           }

    assert event2 ==
             %ShowsStore.Schemas.Show{
               date: ~U[2019-08-20 20:30:00Z],
               price: 22.0,
               link: "http://leferrailleur.fr/evenement/walls-of-jericho-stinky/3166",
               venue: le_ferrailleur,
               bands: [
                 %ShowsStore.Schemas.Band{
                   name: "Walls of jericho",
                   website: "https://www.facebook.com/WallsofJericho/",
                   country: nil,
                   genres: ["Hardcore"]
                 },
                 %ShowsStore.Schemas.Band{
                   name: "Stinky",
                   website: "https://www.facebook.com/Stinkyhc",
                   country: nil,
                   genres: ["Hardcore"]
                 }
               ]
             }

    assert event3 == %ShowsStore.Schemas.Show{
             date: ~U[2019-08-30 22:00:00Z],
             price: 0.0,
             link: "http://leferrailleur.fr/evenement/fete-du-slip-2/3276",
             venue: le_ferrailleur,
             bands: [
               %ShowsStore.Schemas.Band{
                 name: "Fête du slip",
                 website: nil,
                 country: nil,
                 genres: ["Techno"]
               },
               %ShowsStore.Schemas.Band{
                 name: "Justin(e)",
                 website: "https://www.facebook.com/justinepunkrock",
                 country: nil,
                 genres: ["Punk"]
               }
             ]
           }
  end
end
