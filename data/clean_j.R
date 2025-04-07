library(RSQLite)
library(sf)
library(dplyr)
library(leaflet)
library(ggplot2)
library(plotly)
conn <- dbConnect(RSQLite::SQLite(), "G:/Meine Ablage/Data_solutions/Traffic accidents/data/dtp_uz_26122023.db")
#conn <- dbConnect(RSQLite::SQLite(), "C:/Users/J.Jalolov/Desktop/Traffic accidents/data/dtp_uz_26122023.db")


query <- "SELECT * FROM dtp_uz"
location_data <- dbGetQuery(conn, query)
dbDisconnect(conn)


#######ploting part 
# 1. accident share
data <- location_data %>%  
  filter(region_name_uz == "Toshkent shahri") %>%
  count(accident_type_name_uz)
glimpse(data)


####type of the accidents by share


plot <- plot_ly(data, 
                labels = ~accident_type_name_uz, 
                values = ~n, 
                type = 'pie', 
                hole = 0.4, 
                hoverinfo = "label+percent") %>%
  layout(
    legend = list(x = 1.05, 
                  y = 0.5, 
                  orientation = 'v'),
    plot_bgcolor = "transparent",
    paper_bgcolor = "transparent"
  ) %>%
  config(displaylogo = FALSE, 
         modeBarButtons = list(list("toImage"),
                               list("zoomIn2d"),
                               list("zoomOut2d"),
                               list("resetScale2d"))
  )
plot

####data cleaning for bar chart
location_data$date_accident <- as.POSIXct(location_data$date_accident, format = "%Y-%m-%dT%H:%M:%S")
location_data$year <- format(location_data$date_accident, "%Y")
table(location_data$year)                

databar <- location_data %>%
  filter(region_name_uz == "Toshkent shahri", year > 2010) %>%
  group_by(year) %>%
  count()

# 2. barchart
color_scale <- colorRamp(c("#ff9999", "#ff0000")) 

# values to a 0-1 scale
normalized_values <- (databar$n - min(databar$n)) / (max(databar$n) - min(databar$n))

# scale the color to the normalized values
bar_colors <- apply(matrix(normalized_values), 1, function(v) rgb(color_scale(v), maxColorValue = 255))

# barplot
bar <- plot_ly(databar, x = ~year, y = ~n, type = 'bar', marker = list(color = bar_colors)) %>%
  layout(
    xaxis = list(title = "", showticklabels = TRUE),
    yaxis = list(title = "Number of Accidents"),
    plot_bgcolor = "transparent",
    paper_bgcolor = "transparent"
  ) %>%
  config(displaylogo = FALSE, 
         modeBarButtons = list(list("toImage"),
                               list("zoomIn2d"),
                               list("zoomOut2d"),
                               list("resetScale2d"))
  )
bar

### data cleaning for road_condition_name_uz
# 3.road condition
data1 <- location_data %>%  
  filter(region_name_uz == "Toshkent shahri") %>%
  count(road_condition_name_uz)
glimpse(data1)
data1 <- na.omit(data1)

plot <- plot_ly(data1, 
                labels = ~road_condition_name_uz, 
                values = ~n, 
                type = 'pie', 
                hole = 0.4, 
                hoverinfo = "label+percent") %>%
  layout(
    legend = list(x = 1.05, 
                  y = 0.5, 
                  orientation = 'v'),
    plot_bgcolor = "transparent",
    paper_bgcolor = "transparent"
  ) %>%
  config(displaylogo = FALSE, 
         modeBarButtons = list(list("toImage"),
                               list("zoomIn2d"),
                               list("zoomOut2d"),
                               list("resetScale2d"))
  )
plot


### data cleaning for weather_condition_name_uz
# 4.weather condition

data2 <- location_data %>%  
  filter(region_name_uz == "Toshkent shahri") %>%
  count(weather_condition_name_uz)
glimpse(data2)
data1 <- na.omit(data2)

plot <- plot_ly(data1, 
                labels = ~weather_condition_name_uz, 
                values = ~n, 
                type = 'pie', 
                hole = 0.4, 
                hoverinfo = "label+percent") %>%
  layout(
    legend = list(x = 1.05, 
                  y = 0.5, 
                  orientation = 'v'),
    plot_bgcolor = "transparent",
    paper_bgcolor = "transparent"
  ) %>%
  config(displaylogo = FALSE, 
         modeBarButtons = list(list("toImage"),
                               list("zoomIn2d"),
                               list("zoomOut2d"),
                               list("resetScale2d"))
  )
plot








## check other variables
colnames<-as.data.frame(colnames(location_data))
table(location_data$region_name_uz)
table(location_data$district_name_uz)
table(location_data$distance_from)
table(location_data$road_surface_name_uz)
table(location_data$road_part_name_uz)
table(location_data$participants_1_violation_1_name_uz)
table(location_data$participants_1_age)
table(location_data$participants_1_gender_type)
table(location_data$participants_1_vehicle)
table(location_data$participants_2_violation_1_name_uz)
table(location_data$participants_2_violation_1_name_uz)
table(location_data$accident_causal_5_name_uz)







################################## new charts #############################
## viloyatlar gradient map. all obs have these feature. only 6362 missings
## tumanlar gradient map. all obs have these feature. only 7399 missings
## road_part_name_uz pie chart. balki boshqa pie chartlar bilan birga esquisse orqali chizadigan qilarmiz. faqat o'zimiz bergan data bilan. 
  # yoki 1ta pie chart qo'yib variable select qilish imkonini berish kerak 
##########participant_1 yoki 2 yoki 3 etc. aybdor participant. aybdorni aniqlash kerak:
## participants_1_violation_1_name_uz. qoida buzarlik turi bo'yicha pie yoki bar chart
## participants_1_age aybdorning yoshi. guruhlash kerak. masalan, 0-20, 20-30 vh h.k. bar chart yaxshi chiqsa kerak
## participants_1_gender_type aybdoring jinsi. pie chart. yoki yosh bar chartida har xil fill color

## died participantlar sonini sanash