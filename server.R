source('share_load.R')

server <- 
  function(input, output, session) {
    
    color_palette <- colorRampPalette(c("#008000", "#FEB24C", "#FC4E2A", "#E31A1C", "#BD0026", "#800026"))
    palt <- colorNumeric(palette = color_palette(4), domain = merged_data_sf_t$point_count)
    
    observe({
      updatePickerInput(session, "streetName", choices = street_names)
    })
    
    
    filtered_street <- reactive({
      req(input$streetName)  # Make sure a street name is selected
      merged_data_sf_t[merged_data_sf_t$name_en == input$streetName, ]
    })
    
    
    # Reactive output for dynamic map
    output$dynamicMap <- renderUI({
      if (input$mapType == "tmap") {
        leafletOutput('tmap', width = "100%", height = "710px")
      } else if (input$mapType == "pmap") {
        leafletOutput('pmap', width = "100%", height = "710px")
      } else if (input$mapType == "searchmap") {
        leafletOutput('searchmap', width = "100%", height = "710px")
      }
    })
    
    # Render the Leaflet map 1
    output$tmap <- renderLeaflet({
      map <- leaflet(merged_data_sf_t, options = leafletOptions(minZoom = 10)) %>%
        addProviderTiles(providers$Esri.WorldImagery) %>%
        setView(lng = 69.25411937864908, lat = 41.31687112633275, zoom = 15) %>%
        addPolygons(
          fillColor = ~palt(point_count),
          color = "#FFFFFF",  
          weight = 1,  
          smoothFactor = 0.5,  
          opacity = 0.8,  
          fillOpacity = 0.7,  
          highlightOptions = highlightOptions(
            weight = 2,
            color = "#666666",  
            fillOpacity = 0.9,
            bringToFront = TRUE),
          popup = ~paste("<b>", "Street name:", "</b>", name_en, "<br/>", 
                         "<b>", "Number of traffic accidents:", "</b>", round(point_count, 0),"<br/>",
                         "<b>", "Length of the street segment:",  "</b>", seg_length),
          labelOptions = labelOptions(
            style = list("background" = "rgba(255, 255, 255, 0.8)", "font-weight" = "normal", "padding" = "5px", "border" = "1px solid #cccccc", "border-radius" = "4px"),
            textsize = "15px",
            direction = "auto",
            html = TRUE)
        ) %>%
        addLegend(
          pal = palt,
          values = ~point_count,
          opacity = 1,
          title = "Traffic Accidents",
          position = "bottomright"
        )
      
      # Conditionally add markers based on checkbox
      if(input$showIcons) {
        map <- map %>% addMarkers(data = json_data_tl,
                                  icon = myCustomIcon,
                                  popup = ~paste("<b>", "Yo'l belgisi:", "</b>", "Svetofor", "<br/>")
        )
      }
      
      map
      
      
      
    })
    
    
    color_palette1 <- colorRampPalette(c( "#008000", "#FEB24C", "#FC4E2A", "#E31A1C", "#800026"))
    pal1 <- colorNumeric(palette = color_palette1(6), domain = merged_data_sf_p$point_count)
    
    
    # Render the Leaflet map 2
    output$pmap <- renderLeaflet({
      map2 <- leaflet(merged_data_sf_p, options = leafletOptions(minZoom = 10)) %>%
        addProviderTiles(providers$Esri.WorldImagery) %>%
        setView(lng = 69.25411937864908, lat = 41.31687112633275, zoom = 15) %>%
        addPolygons(
          fillColor = ~pal1(point_count),
          color = "#FFFFFF",  # border color white is better
          weight = 1,  #weight of the border
          smoothFactor = 0.5,  
          opacity = 0.8,  
          fillOpacity = 0.7,  
          highlightOptions = highlightOptions(
            weight = 2,
            color = "#666666",  
            fillOpacity = 0.9,
            bringToFront = TRUE),
          popup = ~paste("<b>", "Street name:", "</b>", name_en, "<br/>", 
                         "<b>", "Number of traffic accidents:", "</b>", round(point_count, 0),"<br/>",
                         "<b>", "Length of the street segment:",  "</b>", seg_length),
          labelOptions = labelOptions(
            style = list("background" = "rgba(255, 255, 255, 0.8)", "font-weight" = "normal", "padding" = "5px", "border" = "1px solid #cccccc", "border-radius" = "4px"),
            textsize = "15px",
            direction = "auto",
            html = TRUE)
        ) %>%
#        addMarkers(data = json_data,
 #                  icon = myCustomIcon1,
  #                 popup = ~paste("<b>", "Yo'l belgisi:", "</b>", "Piyodalar o'tish joyi", "<br/>")
   #     ) %>%
        addLegend(
          pal = pal1,
          values = ~point_count,
          opacity = 1,
          title = "Traffic Accidents",
          position = "bottomright"
        ) 
      
      # Conditionally add markers based on checkbox
      if(input$showIcons) {
        map2 <- map2 %>% addMarkers(data = json_data_tl,
                                  icon = myCustomIcon1,
                                  popup = ~paste("<b>", "Yo'l belgisi:", "</b>", "Piyodalar o'tish joyi", "<br/>")
        )
      }
      
      map2
      
      
      
    })
    
    
    output$searchmap <- renderLeaflet({
      leaflet() %>%
        addProviderTiles(providers$Esri.WorldImagery)%>%
        setView(lng = 69.25411937864908, lat = 41.31687112633275, zoom = 14)
    })
    
    observe({
      req(input$streetName)
      
      # Filter data based on selected street name
      street_data <- merged_data_sf_t[merged_data_sf_t$name_en == input$streetName, ]
      
      # Filter json_data_tl for the selected street as well
      # json_data_filtered <- json_data_tl[json_data_tl$street_name_field == input$streetName, ]  
      
      # Calculate bounds for the selected street
      bounds <- sf::st_bbox(street_data)
      bounds_df <- data.frame(xmin = bounds["xmin"],
                              ymin = bounds["ymin"],
                              xmax = bounds["xmax"],
                              ymax = bounds["ymax"])
      center_lat <- (bounds_df$ymin + bounds_df$ymax) / 2
      center_lng <- (bounds_df$xmin + bounds_df$xmax) / 2
      
      # Use leafletProxy to update the map
      leafletProxy("searchmap", data = street_data) %>%
        clearShapes() %>%
        clearMarkers() %>%
        clearControls() %>%
        setView(lng = center_lng, lat = center_lat, zoom = 15) %>%
        addPolygons(
          data = street_data,
          fillColor = ~palt(point_count),
          color = "#FFFFFF",
          weight = 1,
          smoothFactor = 0.5,
          opacity = 0.8,
          fillOpacity = 0.7,
          highlightOptions = highlightOptions(
            weight = 2,
            color = "#666666",
            fillOpacity = 0.9,
            bringToFront = TRUE),
          popup = ~paste("<b>Street name:</b>", name_en, "<br/>",
                         "<b>Number of traffic accidents:</b>", round(point_count, 0), "<br/>",
                         "<b>Length of the street segment:</b>", seg_length)
        ) %>%
       # addMarkers(
        #  data = json_data_tl,  # Use the filtered data here
        #  icon = myCustomIcon,
        #  popup = ~paste("<b>Yo'l belgisi:</b>", "Svetafor", "<br/>")
       # )%>%
        addLegend(
          pal = palt,
          values = ~point_count,
          opacity = 1,
          title = "Traffic Accidents",
          position = "bottomright"
        )
    })
    
    
    data <- dataset_clean %>%
      count(accident_type_name_en)
    #plot1

    output$plot1 <- renderPlotly({
        # Your plot_ly code
        plot <- plot_ly(data,
                        labels = ~accident_type_name_en,
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
      })
    data_age_s <- data_c %>%
      group_by(age_segments_en) %>%
      count()
    
    #plot4
    
    output$plot4 <- renderPlotly({
      # If 'data_age_s' is reactive, ensure you call it as a function e.g., data_age_s()
      plot_ly(data_age_s,
              labels = ~age_segments_en,
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
    })

    data_3 <- dataset_clean %>%
      filter(accident_type_name_uz == "to'qnashuv", participants_1_type == "driver") %>%
      group_by(participants_1_violation_1_name_en) %>%
      count()
    
    
    data_3 <- data_3 %>%
      arrange(desc(n))
    data_3$wrapped_labels <- gsub(" ", "<br>", data_3$participants_1_violation_1_name_en)
    
    # plot2
    #
    #
  output$plot2 <- renderPlotly({
   plot_ly(data_3[c(2,3,5), ], x = ~wrapped_labels, y = ~n, type = 'bar', marker = list(color = bar_colors)) %>%
    layout(title = list(
      text = "",
      font = list(size = 24),  
      y = 0.991               
    ),
    xaxis = list(
      title = "",
      showticklabels = TRUE,
      tickangle = 360, 
      automargin = TRUE 
    ),
    yaxis = list(
      title = "",
      automargin = TRUE
    ), 
    plot_bgcolor = "transparent",
    paper_bgcolor = "transparent"
    ) %>%
      config(displaylogo = FALSE, 
             modeBarButtons = list(list("toImage"),
                                   list("zoomIn2d"),
                                   list("zoomOut2d"),
                                   list("resetScale2d"))
      )
  })
    #
    #
  data_4 <- dataset_clean %>%
    filter(accident_type_name_uz == "to'qnashuv", participants_2_type == "driver") %>%
    group_by(participants_2_violation_1_name_en) %>%
    count()
  
  
  
  data_4 <- data_4 %>%
    arrange(desc(n))
  data_4$wrapped_labels <- gsub(" ", "<br>", data_4$participants_2_violation_1_name_en)
  
    # plot3
    #
  output$plot3 <- renderPlotly({
  plot_ly(data_4[c(2:4), ], x = ~wrapped_labels, y = ~n, type = 'bar', marker = list(color = bar_colors)) %>%
    layout(title = list(
      text = "",
      font = list(size = 24),  
      y = 0.995                
    ),
    xaxis = list(
      title = "",
      showticklabels = TRUE,
      tickangle = 360, 
      automargin = TRUE 
    ),
    yaxis = list(
      title = "",
      automargin = TRUE
    ), 
    plot_bgcolor = "transparent",
    paper_bgcolor = "transparent"
    ) %>%
    config(displaylogo = FALSE, 
           modeBarButtons = list(list("toImage"),
                                 list("zoomIn2d"),
                                 list("zoomOut2d"),
                                 list("resetScale2d"))
    )
 })
    #
     

      data_1 <- dataset_clean %>%
        filter(accident_type_name_uz == "piyodani urib yuborish", participants_1_type == "driver") %>%
        group_by(participants_1_violation_1_name_en) %>%
        count()
      
      data_1 <- data_1 %>%
        arrange(desc(n))
      data_1$wrapped_labels <- gsub(" ", "<br>", data_1$participants_1_violation_1_name_en)
      
    #
    #   plot5
    #
    #
        output$plot5 <- renderPlotly({
          # If 'data_violation' is a reactive data source, it should be called as data_violation()
          plot_ly(data_1[c(1,2,4), ], x = ~wrapped_labels, y = ~n, type = 'bar', marker = list(color = bar_colors)) %>%
            layout(title = list(
              text = "",
              font = list(size = 24),  
              y = 0.97                
            ),
            xaxis = list(
              title = "",
              showticklabels = TRUE,
              tickangle = 360, 
              automargin = TRUE 
            ),
            yaxis = list(
              title = "",
              automargin = TRUE
            ), 
            plot_bgcolor = "transparent",
            paper_bgcolor = "transparent"
            ) %>%
            config(displaylogo = FALSE, 
                   modeBarButtons = list(list("toImage"),
                                         list("zoomIn2d"),
                                         list("zoomOut2d"),
                                         list("resetScale2d"))
            )
        })


        data_2 <- dataset_clean %>%
          filter(accident_type_name_uz == "piyodani urib yuborish", participants_2_type == "pedestrian") %>%
          group_by(participants_2_violation_1_name_en) %>%
          count()
        
        
        
        data_2 <- data_2 %>%
          arrange(desc(n))
        data_2$wrapped_labels <- gsub(" ", "<br>", data_2$participants_2_violation_1_name_en)
        
    #   plot6
    #
        output$plot6 <- renderPlotly({
        plot_ly(data_2[c(2:4), ], x = ~wrapped_labels, y = ~n, type = 'bar', marker = list(color = bar_colors)) %>%
          layout(title = list(
            text = "",
            font = list(size = 24),  
            y = 0.97                
          ),
          xaxis = list(
            title = "",
            showticklabels = TRUE,
            tickangle = 360, 
            automargin = TRUE 
          ),
          yaxis = list(
            title = "",
            automargin = TRUE
          ), 
          plot_bgcolor = "transparent",
          paper_bgcolor = "transparent"
          ) %>%
          config(displaylogo = FALSE, 
                 modeBarButtons = list(list("toImage"),
                                       list("zoomIn2d"),
                                       list("zoomOut2d"),
                                       list("resetScale2d"))
          )
     })
    #
        databar <- dataset_clean %>%
          group_by(day_hour) %>%
          count()
        
        # Create a color ramp function
        # color_scale <- colorRamp(c("white", "#E51A4B"))  # Adjust the colors as needed
        # 
        # # Normalize the values to a 0-1 scale
        # normalized_values <- (databar$n - min(databar$n)) / (max(databar$n) - min(databar$n))
        # 
        # # Apply the color ramp to the normalized values to get hex colors
        # bar_colors <- sapply(normalized_values, function(v) rgb(color_scale(v), maxColorValue = 1))
        
        # Plot7
        output$plot7 <- renderPlotly({
          plot_ly(databar, x = ~day_hour, y = ~n, type = 'bar', marker = list(color = '#E51A4B')) %>%
            layout(
              xaxis = list(
                title = "Time",
                showticklabels = TRUE,
                tickangle = 360,
                tickvals = ~day_hour,
                ticktext = ~day_hour
              ),
              yaxis = list(title = "Number of traffic accidents"),
              plot_bgcolor = "transparent",
              paper_bgcolor = "transparent"
            ) %>%
            config(displaylogo = FALSE,
                   modeBarButtons = list(list("toImage"),
                                         list("zoomIn2d"),
                                         list("zoomOut2d"),
                                         list("resetScale2d"))
            )
        })

    #       #plot8
    #
          databar11 <- dataset_clean %>%
            group_by(day_hour) %>%
            count()
          
            output$plot8 <- renderPlotly({
              plot_ly(databar11,
                      labels = ~day_hour,
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
            })

            databar1 <- dataset_clean %>%
              group_by(day_name_en, day_of_week) %>%
              count()

            # 2. barchart
            color_scale <- colorRamp("#E51A4B")

            # values to a 0-1 scale
            normalized_values <- (databar1$n - min(databar1$n)) / (max(databar1$n) - min(databar1$n))

            # scale the color to the normalized values
            bar_colors <- apply(matrix(normalized_values), 1, function(v) rgb(color_scale(v), maxColorValue = 255))


            databar1 <- databar1 %>%
              arrange(day_of_week)

        #plot9

                output$plot9 <- renderPlotly({
                plot_ly(databar1, x = ~day_name_en, y = ~n, type = 'bar', marker = list(color = bar_colors)) %>%
                  layout(
                    xaxis = list(
                      title = "",
                      showticklabels = TRUE,
                      tickangle = 315,
                      tickvals = ~day_name_en,
                      ticktext = ~day_name_en
                    ),
                    yaxis = list(title = "Number of traffic accidents"),
                    plot_bgcolor = "transparent",
                    paper_bgcolor = "transparent"
                  ) %>%
                  config(displaylogo = FALSE,
                         modeBarButtons = list(list("toImage"),
                                               list("zoomIn2d"),
                                               list("zoomOut2d"),
                                               list("resetScale2d"))
                  )
              })


            #plot10
                  output$plot10 <- renderPlotly({
                    # If 'databar' is reactive, you should call it as a function e.g., databar()
                    plot_ly(databar1,
                            labels = ~day_name,
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
                  })


  }