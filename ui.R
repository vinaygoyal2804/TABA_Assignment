# Required libraries
library("shiny")

ui <- shinyUI(
  fluidPage(
    
    titlePanel("Car reviews"),  # name the shiny app
    
    sidebarLayout(    # creates a sidebar layout to be filled in
      
      sidebarPanel(   # creates a panel struc in the sidebar layout 
        
        # user reads input file into input box here:
        fileInput("file", "Upload data (csv file with header)", multiple = TRUE, accept = c(".csv")),
        span(strong(p("Note: Please upload one file at a time."))),
        
        # user selects the optimal num of clusters:
        checkboxGroupInput("Keywords", "Select Keywords : ", 
                           choices = c('airbag','engine','seat','price range', 'driving experience',
                                       'boot space','infotainment system','voice command',
                                       'touch screen','air purifier','ground clearance',
                                       'sunroof','design','interior','value for money')),
        actionLink("selectall","Select All"),
        br(),
        br(),
        
        # actionButton("goButton", "Go",icon = NULL,width = "100px")
      ),   # end of sidebar panel
      
      ## Main Panel area begins.
      mainPanel(
        
        tabsetPanel(type = "tabs",   # builds tab struc
                    
                    tabPanel("Overview",   # leftmost tab
                             
                             h4(p("Data input")),
                             
                             p("This app supports only comma separated values (.csv) data file. CSV data file should have headers", align="justify"),
                             
                             p("Please refer to the link below for sample csv file."),
                             a(href="https://github.com/vinaygoyal2804/TABA_Assignment/blob/master/SeltosCarReviews.csv"
                               ,"Sample data input file"),   
                             
                             br(),
                             
                             h4('How to use this App'),
                             
                             p('To use this app, click on', 
                               span(strong("Upload data (csv file with header)")),
                               'and upload the csv data file. You can select the keywords based on which the sentences will be filtered from the uploaded csv file')),
                    
                    # second tab coming up:
                    tabPanel("Matched Reviews file", 
                             
                             # plot1 object returned by server.R
                             tableOutput('Matched_Reviews')),
                    
                    # third tab coming up:
                    tabPanel("Bar Chart",
                             
                             # obj 'clust_summary' from server.R
                             plotOutput('Matched_Reviews_Bar_Chart')),
                    
                    # fourth tab coming up:
                    tabPanel("Word Cloud",
                             
                             plotOutput('Matched_Reviews_Word_Cloud'))
                    
        ) # end of tabsetPanel
      )# end of main panel
    ) # end of sidebarLayout
  )  # end if fluidPage
) # end of UI