##  load library --------------------
library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(dplyr)
library(tidyr)
library(ggplot2)
library(lubridate)
library(stringr)
library(shinyjs)
library(plotly)
library(shinythemes)
library(shinyWidgets)
library(htmltools)
library(htmlwidgets)
library(shinymaterial)
#library(ranger)
library(forcats)
library(shinycssloaders)
#library(readxl)
library(leaflet)
library(RColorBrewer)
#library(RSQLite)
library(sf)
library(jsonlite)

#setwd("C:/Users/User/Desktop/Hackathon")
#setwd("G:/Meine Ablage/Data_solutions/Traffic accidents/Traffic accidents_new_en")
#setwd("D:/ELDOR/PROJECTS/LINK DATA/PROJECTS/Traffic Accidents")

#dataset_clean <- readRDS("dataset_clean.rds")
#data_c <- readRDS("data_c.rds")
merged_data_sf <- readRDS("merged_data_sf_translated.rds")
merged_data_sf_p <- readRDS("merged_data_sf_p_translated.rds")
merged_data_sf_t <- readRDS("merged_data_sf_t_translated.rds")
dataset_clean <- readRDS("dataset_clean_translated.rds")
data_c <- readRDS("data_c_translated.rds")
json_data <- st_read("crossing.geojson")
json_data_tl <- st_read("traffic_signals.geojson")

json_data_tl <- json_data_tl[-1474,]
merged_data_sf_t$name_en <- gsub("\\?", "'", merged_data_sf_t$name_en)

street_names <- data.frame(sort(unique(merged_data_sf_t$name_en)))
colnames(street_names) <- "Street names"

# Named vector for translation
weekday_translation <- c(
  "Dushanba"   = "Monday",
  "Seshanba"   = "Tuesday",
  "Chorshanba" = "Wednesday",
  "Payshanba"  = "Thursday",
  "Juma"       = "Friday",
  "Shanba"     = "Saturday",
  "Yakshanba"  = "Sunday"
)

# Apply to your dataframe
dataset_clean$day_name_en <- weekday_translation[dataset_clean$day_name]







myCustomIcon <- makeIcon(
  iconUrl = "5.png",  
  iconWidth = 30, iconHeight = 30,
  iconAnchorX = 12, iconAnchorY = 41
)


myCustomIcon1 <- makeIcon(
  iconUrl = "7.png",  
  iconWidth = 40, iconHeight = 40,
  iconAnchorX = 12, iconAnchorY = 41
)

