
fluidPage(
  titlePanel("Fatalities Across the United States"),
  
  sidebarLayout(
    sidebarPanel(
      conditionalPanel(condition="input.conditionedPanels==1",
                       sliderInput('YearA', label = 'Select the Range of Years', 
                       min = 2011, max = 2015, value = c(2011,2015),
                       sep='', dragRange = T),
                       selectInput('TypeofdataA', label = 'Select the indicator', 
                       choices = c('Work Related Fatalities',
                                   'Fatality Frequency Rate',
                                   'Lost Time Cases',
                                   'Lost Time Cases Frequency Rate'),
                       selected = 'Work Related Fatalities',
                       multiple = FALSE)
                      ),

      conditionalPanel(condition="input.conditionedPanels==2",
                       sliderInput('YearB', label = 'Select the Range of Years', 
                                   min = 2011, max = 2015, value = c(2011,2015),
                                   sep='', dragRange = T),
                       selectInput('TypeofdataB', label = 'Select the indicator', 
                                   choices = c('Work Related Fatalities',
                                               'Fatality Frequency Rate',
                                               'Lost Time Cases',
                                               'Lost Time Cases Frequency Rate'),
                                   selected = 'Work Related Fatalities',
                                   multiple = FALSE),
                       checkboxInput('bar', 'Select All State/Total US',value=F),
                       checkboxGroupInput("Selstates", label = "Select the States You Want to See", 
                                  choices = choice,
                                  selected = 'US')
                       ),
      
      conditionalPanel(condition="input.conditionedPanels==3",
                       selectInput('TypeofdataD', label = 'Select the indicator', 
                                   choices = c('Work Related Fatalities',
                                               'Lost Time Cases'),
                                   selected = 'Work Related Fatalities',
                                   multiple = FALSE),
                       radioButtons("typeofchartB", label = "Choose the type of chart you want to see",
                                    choices = c("Proportion" = "fill","Numbers" = "stack"),
                                    selected = 'stack'),
                       radioButtons("stateevol", label = "Choose a State",
                                    choices = choice,
                                    selected = 'US')
                      ),
      
      conditionalPanel(condition="input.conditionedPanels==4",
                       sliderInput('YearZ', label = 'Select the Range of Years', 
                                   min = 2011, max = 2015, value = c(2011,2015),
                                   sep='', dragRange = T),
                       radioButtons("stateevolZ", label = "Choose a State",
                                    choices = choice,
                                    selected = 'US')
                      ),
      
      conditionalPanel(condition="input.conditionedPanels==5",
                       sliderInput('YearC', label = 'Select the Range of Years', 
                                   min = 2011, max = 2015, value = c(2011,2015),
                                   sep='', dragRange = T),
                       checkboxInput('bar2', 'Select All State/Total US',value=T),
                       checkboxGroupInput("Selstates2", label = "Select the States You Want to See", 
                                          choices = choice,
                                          selected = choice)
                       ),
      width = 3
  ),
  
    mainPanel(
      tabsetPanel(
        tabPanel('Map', value = 1,
                 htmlOutput('map'), width = "100%",
                 verbatimTextOutput('text')),
        tabPanel('States Comparison', value = 2,
                 h5("\n"),
                 plotlyOutput("graph1"),
                 h1(" \n "),
                 radioButtons("typeofchart", label = "Choose the type of chart you want to see",
                              choices = c("Proportion" = "fill","Numbers" = "stack"),
                              selected = 'fill'),
                 plotlyOutput("graph2")),
        tabPanel("Yearly Evolution", value = 3,
                 plotlyOutput("graph9"),
                 plotlyOutput("graph10")),
        tabPanel("Fatalities x Lost Time Cases", value = 4,
                 splitLayout(style = "border: 1px solid silver:", cellWidths = c(450,450), 
                             htmlOutput('piechart1'),
                             htmlOutput('piechart2'))
                 ),
        tabPanel("Table", value = 5,
                 htmlOutput("tablefinal")),       
        id = "conditionedPanels"
      )
    )
  )
)