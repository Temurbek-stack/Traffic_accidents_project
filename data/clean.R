library(RSQLite)
library(sf)
library(dplyr)
library(leaflet)

conn <- dbConnect(RSQLite::SQLite(), "G:/Meine Ablage/Data_solutions/Traffic accidents/data/dtp_uz_26122023.db")

query <- "SELECT * FROM dtp_uz"
location_data <- dbGetQuery(conn, query)
dbDisconnect(conn)

saveRDS(location_data, "G:/Meine Ablage/Data_solutions/Traffic accidents/data/raw_data_dtp.rds")


data <- location_data %>%
  filter(location!="") %>%
  filter(region_name_uz == "Toshkent shahri") %>%
  select(location, street_name,accident_type_name_uz)

coords <- strsplit(as.character(data$location), "[, ]") # Adjust the regex based on your actual delimiter
coords <- matrix(unlist(coords), ncol = 2, byrow = TRUE)
data$lat <- as.numeric(coords[, 1])
data$lon <- as.numeric(coords[, 2])

sf_data <- st_as_sf(data, coords = c("lon", "lat"), crs = 4326)


st_write(sf_data, "G:/Meine Ablage/Data_solutions/Traffic accidents/shapefiles/dtp_shapefile/dtp_tash_shapefile_new.shp", layer_options = "ENCODING=UTF-8")

leaflet(data) %>% 
  addTiles() %>%
  addMarkers(lng = ~lon, lat = ~lat) 




test <- readRDS("G:/Meine Ablage/Data_solutions/Traffic accidents/data/raw_data_dtp.rds")
