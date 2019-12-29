# Required libraries
library(shiny)
library(dplyr)
library(tidytext)
library(textrank)
library(ggplot2)
library(tidyverse)
library(RColorBrewer)
library(wordcloud)

server <- shinyServer(function(input, output,session) {
  
  keyword_list <- c('airbag','engine','seat','price range', 'driving experience',
                    'boot space','infotainment system','voice command',
                    'touch screen','air purifier','ground clearance',
                    'sunroof','design','interior','value for money')
  
  # Select all action link
  observe({
    if(input$selectall == 0) return(NULL)
    else if (input$selectall%%2 == 0)
    {
      updateCheckboxGroupInput(session,"Keywords","Select Keywords : ",choices=keyword_list)
    }
    else
    {
      updateCheckboxGroupInput(session,"Keywords","Select Keywords : ",choices=keyword_list,selected=keyword_list)
    }
  })
  
  
  Dataset <- reactive({
    if (is.null(input$file)) { return(NULL) } 
    
    else
    {
      req(input$file)
      upload = list()

      for(i in 1:length(input$file[, 1])){
        upload[[i]] <- read.csv(input$file[[i, 'datapath']])
        
      }
      reviews<- as.data.frame(upload)
      reviews_text<- as.data.frame(reviews$Review.text)
      colnames(reviews_text) <- "sentence"
      return(reviews_text)
      
    }  # else stmt ends
    
  })  # reactive stmt ends
  
  Filtered_Sentences <- reactive({
    
    custom_stop_words <- bind_rows(stop_words, tibble(word = c("kia", "seltos","car"), lexicon = rep("custom", 3)))
    data <- Dataset()
    data$feature<-NA
    data$sentence <- tolower(data$sentence) 
    
    for (feature in input$Keywords){
      data$feature <- ifelse(grepl(feature,data$sentence),feature,data$feature)}
    
    
    Keyword_Sentences <- as.data.frame(data[!is.na(data$feature),])
    
    return(Keyword_Sentences)
    
  })
  
  # 'Matched_Reviews' is output obj for tab 2:
  output$Matched_Reviews = renderTable({
    
    return(Filtered_Sentences())
    
    #df%>%filter(feature=="price range")%>%select(sentence,sent_sentiment)
    
  })
  
  
  # 'Matched_Reviews_Bar_Chart' is outp obj for tab 3:
  output$Matched_Reviews_Bar_Chart = renderPlot({
  
    Keyword_Sentences <- Filtered_Sentences()
    Keyword_Sentences %>% select(feature) %>% group_by(feature) %>% count(feature,sort = TRUE) %>%
      rename(count = n)%>%          # renames the count column from 'n' (default name) to 'count'.
      ggplot(aes(reorder(feature, count), count)) +
      geom_bar(stat = "identity", col = "red", fill = "red") +
      xlab(NULL) +
      coord_flip()

  })
  
  # 'Matched_Reviews_Word_Cloud' is outp obj for last tab:
  
  output$Matched_Reviews_Word_Cloud = renderPlot({
    
    pal <- brewer.pal(8,"Dark2")
    Keyword_Sentences <- Filtered_Sentences()
    Keyword_Sentences %>% select(feature) %>% group_by(feature) %>% count(feature,sort = TRUE) %>%
      rename(count = n) %>% 
      with(wordcloud(feature, count , random.order = FALSE, max.words = 50,colors=pal))
    
  })
  
})  # server.R file ends