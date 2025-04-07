# 🚦 Traffic Accidents Analysis in Tashkent – Interactive R Shiny App

## 📊 Overview

This interactive ShinyApp provides a comprehensive analysis of **road traffic accidents in Tashkent**, the capital of Uzbekistan. It visualizes the **types**, **causes**, and **locations** of traffic accidents to support **data-driven decisions** aimed at improving **urban safety**, **traffic regulation**, and **infrastructure planning**.

By enabling policymakers, urban planners, and citizens to explore spatial and statistical patterns of traffic incidents, the platform helps **identify accident hotspots**, **recognize behavioral patterns**, and **prioritize road safety interventions** where they are most needed.

> 🚀 **Live Demo**: [Click here to launch the app](https://temurbek-shinyapps.shinyapps.io/traffic-accidents-analysis/)

---

## ⚙️ Platform Details

- **Framework**: [R Shiny](https://shiny.rstudio.com/)
- **Deployment**: Hosted on [shinyapps.io](https://www.shinyapps.io/)
- **Languages Used**: R (Shiny, dplyr, plotly, sf, leaflet), Python (osmnx)
- **Data Sources**: Open Data Portal of the Republic of Uzbekistan  
- **Data Period**: February 2023 – November 2024  
- **Data Accessed**: December 2024

---

## 🗂 App Structure

The application consists of **two primary tabs**, each serving a unique purpose:

### 1. **Dashboard**

This tab provides an **interactive summary** of accident statistics across Tashkent. It includes:

- Visualizations of:
  - Types of violations
  - Participant demographics (age)
  - Violation types by **first driver**, **second driver**, and **passengers**
  - Accident timing (hourly, daily, weekday trends)

- Top 3 common violations based on accident types (e.g., pedestrian vs. collision)

> Interactive visualizations are built with `plotly`, enabling tooltips, zooming, and responsive plots.

---

### 2. **Interactive Map**

This tab provides a **spatial interface** to explore traffic accident locations:

#### 🗺️ Map Modes:

1. **Collisions Map** – visualizes the location and frequency of collisions  
2. **Pedestrian Accidents Map** – shows where pedestrian-related incidents occurred  
3. **Street-Level Search** – allows users to select a specific street and explore incidents in that area

#### 🛑 Additional Features:

- Option to **overlay traffic signs and signals**
- Each accident point is buffered and aggregated to its nearest road segment for comparative analysis
- Interactive pop-ups and legends help interpret patterns and clusters

---

## 📦 Data Preparation

All data preparation steps are documented in the **`Data`** folder.

### 🔍 Steps Included:

1. **Cleaning Raw Data** from the Open Data Portal:
   - Standardizing text formats (Uzbek labels)
   - Translating labels to English for international accessibility
   - Handling missing and duplicate entries
   - Filtering for the specified time period

2. **Geospatial Preprocessing with Python**:
   - Using [`osmnx`](https://github.com/gboeing/osmnx) to:
     - Download city road networks
     - Scrape traffic signs and traffic lights
     - Create street segments
   - Buffering segments by a set radius (in meters) to match point-level accident data
   - Counting the number of accident points in each buffer zone

3. **Joining Spatial Layers in R**:
   - Accident points joined to road segment polygons using `sf` and `dplyr`
   - Data exported as `.rds` files for efficient loading in the ShinyApp

---

## 📌 Features Highlight

- 🧠 **Dynamic translations**: all content is originally in Uzbek but translated dynamically for global accessibility
- 🗺️ **Spatial analysis**: combining point and polygon geometries to detect accident-heavy road segments
- 📈 **Custom dashboards**: multiple violation types and actor roles visualized using interactive charts
- 🧭 **Smart filtering**: select specific street segments and observe traffic patterns around them
- 🛑 **Traffic infrastructure overlay**: traffic signs and signals enrich contextual understanding

---

## 🧠 Skills Demonstrated

This project showcases the following technical skills:

- **Data wrangling**: transforming real-world messy datasets into clean analytical tables
- **Data visualization**: building intuitive, interactive charts using plotly, leaflet to communicate key patterns clearly
- **Geospatial analysis**: spatial joins, buffering, and visualization
- **Multi-language integration**: combining Python for spatial data and R for interactive web development
- **Interactive web development**: building fully responsive dashboards using Shiny
- **Deployment**: full deployment of a public app using shinyapps.io
- **Communication**: user-friendly design, bilingual labels, clear structure

---

## 🔍 Future Improvements

- Add time slider to filter accidents over months
- Enable filtering by severity and number of vehicles involved
- Add clustering and heatmaps
- Export custom reports by selected areas

