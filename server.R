
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
#install.packages("shiny")

library(shiny)
library(plotly)
shinyServer(function(input, output) {
  
  studios <- reactive({
    req(input$studio)
    movies %>% filter(studio %in% input$studio) %>% select(title : studio)
  })
  
  title_x <- reactive({
    req(input$x)
    as.character(input$x)
  })
  
  title_y <- reactive({
    req(input$y)
    as.character(input$y)
  })

  output$scatterplot <- renderPlot({
    ggplot(data = movies, aes_string(x = input$x, y = input$y, col = input$z))+
      geom_point()
  })
  output$densityplot <- renderPlot({
    ggplot(data = movies, aes_string(x = input$x)) +
      xlab(title_x()) +
      ylab(title_y()) + 
      geom_density()
  })
  
  output$plot_desc <- renderUI(
    paste0("the above plot shows a relationship between ", title_x(), " & ", title_y())
  ) 
  
  output$moviestudio <- DT::renderDataTable({
    DT::datatable(data = studios(), 
                  options = list(pageLength = 10), 
                  rownames = FALSE)
    })

})

shinyApp(ui = ui, server = shinyServer)
