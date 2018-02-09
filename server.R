
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(plotly)
shinyServer(function(input, output) {

  output$scatterplot <- renderPlot({
    ggplot(data = movies, aes_string(x = input$x, y = input$y, col = input$z))+
      geom_point()
  })
  output$densityplot <- renderPlot({
    ggplot(data = movies, aes_string(x = input$x)) +
      geom_density()
  })
  output$moviestudio <- DT::renderDataTable({
    req(input$studio)
    movie_data <- movies %>% filter(studio %in% input$studio) %>%
      select(title : studio)
    DT::datatable(data = movie_data, 
                  options = list(pageLength = 10), 
                  rownames = FALSE)
    })
})

shinyApp(ui = ui, server = shinyServer)
