library(sf)
library(raster)
library(dplyr)
library(tmap)
library(spData)
library(leaflet)
library(cartogram)
library(googlesheets4)
library(afrihealthsites)
library(countrycode)


# Load Google Sheet describing African open health facility lists
africa_lists <- read_sheet("https://docs.google.com/spreadsheets/d/1Ba4bkYJ8r7tvMAh5KxUOutCYCLHESOwJMzez5bYILiM/edit#gid=1678013670")

# Add column with iso3c codes for use in mapping
africa_lists <- africa_lists %>% 
  mutate(country_iso = countrycode(Country, origin = "country.name", destination = "iso2c")) %>% 
  relocate(country_iso, .after = "Country") %>% 
  mutate(`Open facility list online` = case_when(`Official MFL accessible online` == "Yes" ~ "MoH MFL",
                                                 `Official MFL accessible online` == "No" ~ "Other source",
                                                 `Official MFL accessible online` == "Unclear" ~ "Official status unclear"))

africa <-  world %>%
  filter(continent == "Africa", !is.na(iso_a2)) %>%
  right_join(africa_lists, by = c("iso_a2" = "country_iso")) %>%
  dplyr::select(name_long, `Official MFL accessible online`, `Open facility list online`, Owner, License, 
                `Download format`, `Downloaded data geocoded`, `Health facility data URL`, `About page URL`, 
                `Alternative health facilities data source`, `Last updated`, geom) %>% 
  st_transform("+proj=aea +lat_1=20 +lat_2=-23 +lat_0=0 +lon_0=25")


tmap_mode("view")
tm_shape(africa) + 
  tm_polygons("Open facility list online",
              popup.vars=c("Owner: "="Owner", "License: "="License", "Recognised as official MFL: "="Official MFL accessible online",
                           "Download format: " = "Download format", "Geocoded: "="Downloaded data geocoded", 
                           "Last updated: "="Last updated"))

tmap_mode("plot")



