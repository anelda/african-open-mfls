library(tidyverse)

# Read relevant sheets from downloaded Google Sheet that was shared after request to MoH ----

moz_facilities <- readxl::read_xlsx("~/Downloads/SIS-MA.xlsx", sheet = "US")

moz_types <- readxl::read_xlsx("~/Downloads/SIS-MA.xlsx", sheet = "C")

moz_districts <- readxl::read_xlsx("~/Downloads/SIS-MA.xlsx", sheet = "D")

moz_provinces <- readxl::read_xlsx("~/Downloads/SIS-MA.xlsx", sheet = "P")

# Combine datasets as facility list contain a lot of codes that will not mean something to end-users ----
# Remove duplicate/unwanted columns immediately after join
moz_mfl <- moz_facilities %>% 
  left_join(moz_types, by = c("CC" = "Código")) %>% 
  select(-Icona) %>% 
  left_join(moz_districts, by = c("CD" = "Serial")) %>% 
  select(-c("Código distrito", "Código província")) %>% 
  left_join(moz_provinces, by = c("CP" = "Código província"))

# Save CSV file for later use
write_csv(moz_mfl, "~/Downloads/moz_mfl.csv")

# Clean up workspace
remove(moz_districts, moz_facilities, moz_provinces, moz_types, moz_mfl)