
function(input, output, session) {
  observe({
    updateCheckboxGroupInput(
      session, 'Selstates', choices = choice,
      selected = if (input$bar) choice[1:52] else choice[53]
    )
  })
  
  observe({
    updateCheckboxGroupInput(
      session, 'Selstates2', choices = choice,
      selected = if (input$bar2) choice
    )
  })
  
  mapplot = reactive({
    plotmap %>%
      filter(Year >= input$YearA[1] & Year <= input$YearA[2]) %>%
      filter(State != 'US') %>%
      filter(Category == 'ALL') %>%
      group_by(`State`) %>%
      summarise('Work Related Fatalities' = sum(`Work Related Fatalities`),
                'Lost Time Cases' = sum(`Lost Time Cases`),
                'Fatality Frequency Rate' = sum(`Work Related Fatalities`)*20000000/sum(`MHW`),
                'Lost Time Cases Frequency Rate' = sum(`Lost Time Cases`)*20000000/sum(`MHW`))
      
  })
  
  output$map <- renderGvis({
    mapplot() %>% gvisGeoChart("State", input$TypeofdataA,
                               options=list(region="US", 
                                            displayMode="markers",
                                            resolution="provinces", 
                                            enableRegionInteractivity = T, 
                                            defaultColor = 'gray',
                                            width=900, 
                                            height=500))
  })
  
  output$text = renderPrint({
    if (input$TypeofdataA == "Fatality Frequency Rate") {
      print("Fatality Frequency Rate = Number of Fatalities * 20,000,000 / Man-hours Worked")
      print("20,000,000 represents 10,000 full-time employees working 40 hours per week and 50 weeks per year")
    } else {
      if (input$TypeofdataA == "Lost Time Cases Frequency Rate") {
        print("Lost Time Cases Frequency Rate = Number of Lost Time Cases * 20,000,000 / Man-hours Worked")
        print("20,000,000 represents 10,000 full-time employees working 40 hours per week and 50 weeks per year")
      }
    }
      })
  
  lineplot = reactive({
    plotmap %>%
      filter(Year >= input$YearB[1] & Year <= input$YearB[2]) %>%
      filter(State %in% input$Selstates) %>%
      filter(Category == 'ALL') %>%
      select(Year, State, input$TypeofdataB)
  })
  output$graph1 = renderPlotly({
    A = ggplot(lineplot()) + 
        geom_line(aes(x = Year, y = lineplot()[,input$TypeofdataB] , color= State)) + 
        xlim(2011, 2015) +
        labs(title = "Evolution of the Results per Year", x = 'Year', y = input$TypeofdataB) +
        theme_minimal() +
        theme(plot.margin = unit(c(1, 4, 1, 4), "cm"))
    ggplotly(A)
  })
  
  lineplot2 = reactive({
    plotmap %>%
      filter(Year >= input$YearB[1] & Year <= input$YearB[2]) %>%
      filter(State %in% input$Selstates) %>%
      filter(Category != 'ALL') %>%
      select(Year, State, Category, input$TypeofdataB)
  })
  output$graph2 = renderPlotly({
    if (input$Selstates == "US"){
      B = ggplot(lineplot2(), aes(x = State, y = lineplot2()[,input$TypeofdataB])) +
        geom_bar(aes(fill = lineplot2()$Category), stat = 'identity', width = .25, position = input$typeofchart, show.legend = TRUE) +
        labs(title = 'Results per Category of Occurrence', x = 'State', y = input$TypeofdataB) +
        theme_minimal() +
        theme(
          legend.position = 'right',
          plot.margin = unit(c(.5, 6, .5, 6), "cm"),
          legend.title = element_blank(),
          legend.text = element_text(colour="black", size = 8),
          axis.text.x = element_text(angle=90)
        )
      ggplotly(B) 
    } else {
      B = ggplot(lineplot2(), aes(x = State, y = lineplot2()[,input$TypeofdataB])) +
     geom_bar(aes(fill = lineplot2()$Category), stat = 'identity', position = input$typeofchart, show.legend = TRUE) +
     labs(title = 'Results per Category of Occurrence', x = 'State', y = input$TypeofdataB) +
     theme_minimal() +
     theme(
       legend.position = 'right',
       plot.margin = unit(c(.5, 1, .5, 1), "cm"),
       legend.title = element_blank(),
       legend.text = element_text(colour="black", size = 8),
       axis.text.x = element_text(angle=90)
   )
   ggplotly(B)
    }
 })
  
  horizbar = reactive({
    plotmap %>%
      filter(State == input$stateevol) %>%
      filter(Category != 'ALL') %>%
      select(Year, Category, input$TypeofdataD)
  })
  output$graph9 = renderPlotly({
    C = ggplot(horizbar(), aes(x=Year, y = horizbar()[,input$TypeofdataD], fill = horizbar()[,"Category"])) +
      geom_bar(stat = "identity", position = input$typeofchartB) +
      labs(title = 'Results per Year and Category', x = 'Year', y = input$TypeofdataD) +
      theme_minimal() +
      theme(
        plot.margin = unit(c(.75, 4, .75, 4), "cm"),
        legend.title = element_blank()
      )
    ggplotly(C)
  })
  
  horizbar2 = reactive({
    plotmap %>%
      filter(State == input$stateevol) %>%
      filter(Category == 'ALL') %>%
      select(Year, input$TypeofdataD)
  })
  output$graph10 = renderPlotly({
    D = ggplot(horizbar2(), aes(x=Year, y = horizbar2()[,input$TypeofdataD])) +
      geom_bar(stat = "identity", position = input$typeofchartB, fill = "sky blue") +
      labs(title = 'Results per Year', x = 'Year', y = input$TypeofdataD) +
      theme_minimal() +
      theme(
        plot.margin = unit(c(.75, 4, .75, 4), "cm"),
        legend.title = element_blank()
      )
    ggplotly(D)
  })
  
  
  tablest = reactive({
    A = plotmap %>% 
      filter(Category == 'ALL') %>%
      filter(Year >= input$YearC[1] & Year <= input$YearC[2]) %>%
      filter(State %in% input$Selstates2) %>%
      arrange(-Year) %>%
      group_by(State, Year, `Fatality Frequency Rate`, `Lost Time Cases Frequency Rate`)
    
    A %>%
      group_by(State) %>%
      summarise("Best Fatality Rate" = min(`Fatality Frequency Rate`),
                "Last Fatality Rate" = head(`Fatality Frequency Rate`,1),
                "The Last is the Best?" = ifelse(`Best Fatality Rate` == `Last Fatality Rate`, TRUE, FALSE),
                "Best Lost Time Freq. Rate" = min(`Lost Time Cases Frequency Rate`),
                "Last Lost Time Freq. Rate" = head(`Lost Time Cases Frequency Rate`,1)) 
  })
  
  output$tablefinal = renderGvis({
    gvisTable(tablest(), formats=list('Best Fatality Rate'="#.##",
                                      'Last Fatality Rate'="#.##",
                                      'Best Lost Time Freq. Rate' = "#.##",
                                      'Last Lost Time Freq. Rate' = "#.##"))
  })
  
  pieplot1 = reactive({
    plotmap %>%
      filter(Year >= input$YearZ[1] & Year <= input$YearZ[2]) %>%
      filter(State == input$stateevolZ) %>%
      filter(Category != 'ALL') %>%
      group_by(Category) %>%
      summarise('Work Related Fatalities' = sum(`Work Related Fatalities`, na.rm = T))
  })
  output$piechart1 = renderGvis({
    pieplot1() %>% gvisPieChart(options=list(
      title='Work Related Fatalities per Category',
      pieHole = 0.35,
      height = 400,
      width = 525,
      legend = "{position: 'left', textStyle: {color: 'black', fontSize: 11}}")
    )
  })
  
  pieplot2 = reactive({
    plotmap %>%
      filter(Year >= input$YearZ[1] & Year <= input$YearZ[2]) %>%
      filter(State == input$stateevolZ) %>%
      filter(Category != 'ALL') %>%
      group_by(Category) %>%
      summarise('Lost Time Cases' = sum(`Lost Time Cases`, na.rm = T))
  })
  output$piechart2 = renderGvis({
    pieplot2() %>% gvisPieChart(options=list(
      title='Lost Time Cases per Category',
      pieHole = 0.35,
      height = 400,
      width = 525,
      legend = "{position: 'left', textStyle: {color: 'black', fontSize: 11}}")
    )
  })
  
}