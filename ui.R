source('share_load.R')


ui <- fluidPage(
  theme = shinytheme("cerulean"),
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "animate.min.css"),
    tags$link(rel = "stylesheet", type = "text/css", href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css"),
    tags$script(src = "https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js?config=TeX-MML-AM_CHTML"),
    tags$style(HTML("
      body {
        background-color: #f7f7f7;
        font-family: Arial;
        font-size: 14px;
      }
      .content {
        margin-top: 80px; /* Adjust this value to ensure content is not hidden by navbar */
      }
      /* Other custom CSS */
      #map-row {
        margin-top: 60px;
      }
      .navbar {
        position: fixed; 
        width: 100%; 
        z-index: 100; 
      }
    ")),
    tags$script(HTML("
      $(document).on('shiny:value', function(event) {
        if (event.name === 'predicted_price') {
          window.scrollTo(0, 0);
        }
      });
      $(function () {
        $('[data-toggle=\"tooltip\"]').tooltip();
      });
    "))
  ),
  useShinyjs(), # Initialize shinyjs
  
  navbarPage(
    title = tags$a(tags$img(src = "logo_empty.png", height = "20px", width = "auto")),
    windowTitle = "MyApp",
    id = "nav",
    tabPanel("Dashboard",
             div(class = "content",  # Add a class to push content down
                 
                 
                 h2(paste0("Overview of Road Traffic Accidents in Tashkent City")),
                 #p("Click to show information"),
                 fluidRow( h3(" ", align = 'center'),
                           column( width = 4, offset = 2, h4("Types of Violations", align = 'center'), plotlyOutput('plot1')  ),
                           column( width = 4, h4("Age of Participants", align = 'center'), plotlyOutput('plot4')  ) ),
                 
                 fluidRow( h3(" ", align = 'center'),
                           column( width = 4, offset = 2, h4("Top-3 Violations by First Drivers in Collisions", align = 'center'), plotlyOutput('plot2')  ),
                           column( width = 4, h4("Top-3 Violations by Second Drivers in Collisions", align = 'center'), plotlyOutput('plot3')),
                 ),
                 fluidRow( h3(" ", align = 'center'),
                           column( width = 4,offset = 2, h4("Top-3 Driver Violations in Pedestrian Accidents", align = 'center'), plotlyOutput('plot5')  ),
                           column( width = 4, h4("Top-3 Pedestrian Violations in Pedestrian Accidents", align = 'center'), plotlyOutput('plot6')  ) ),
                 fluidRow( h3(" ", align = 'center'),
                           column( width = 4, offset = 2, h4("Times When Accidents Occurred", align = 'center'), plotlyOutput('plot7')  ),
                           column( width = 4, h4("Weekdays When Accidents Occurred", align = 'center'), plotlyOutput('plot9')  ) ),
                 
             )
    ),
    tabPanel("Interactive Map",
             fluidRow(id = "map-row",
                      uiOutput("dynamicMap"),
                      absolutePanel(id = "mapTypeSelector", class = "panel panel-default", fixed = TRUE,
                                    draggable = TRUE, top = 70, right = 20, bottom = "auto", left = "auto",
                                    style = "opacity: 0.8; z-index: 400; width: 270px;",
                                    div(style = "padding-left: 10px;",
                                        radioButtons("mapType", "Select Map Type:",
                                                     choices = list("Collisions" = "tmap", 
                                                                    "Pedestrian Hit Incidents" = "pmap",
                                                                    "Search by Specific Streets" = "searchmap"),
                                                     inline = FALSE),
                                        checkboxInput("showIcons", "Show Traffic Signs", FALSE)
                                    )

                                    
                                    
                      ),
                      absolutePanel(id = "searchPanel", class = "panel panel-default", fixed = TRUE,
                                    draggable = TRUE, top = 70, left = "50%", right = "auto", bottom = "auto",
                                    style = "opacity: 0.9; z-index: 400; width: 350px; margin-left: -200px;",
                                    div(style = "padding-left: 10px;",
                                    conditionalPanel(
                                      condition = "input.mapType == 'searchmap'",
                                      pickerInput(
                                        inputId = "streetName", 
                                        label = "Select the street",
                                        choices = NULL,  # This will be populated in the server
                                        options = pickerOptions(liveSearch = TRUE),
                                        multiple = FALSE
                                      )
                                    )
                                    )
                      ),
                      width = "100%", height = "80%")
    )
  )
)
