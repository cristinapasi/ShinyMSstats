vals <- reactiveValues(count=0)

isolate(vals$count <- vals$count + 1)

session$onSessionEnded(function(){
  
  isolate(vals$count <- vals$count - 1)
})


output$count <- renderText({
  vals$count
})

foo <- function() {
  data <- read.csv("~/Documents/Shiny-MSstats/dataset.csv", sep = ";")
  prepr <- dataProcess(data)
  matrix <- matrix(c(-1,0,1,0,0,0), nrow = 1)
  row.names(matrix) <- "3 vs 1"
  comp <- groupComparison(contrast.matrix = matrix, data = prepr)
  groupComparisonPlots2(comp$ComparisonResult, type = "VolcanoPlot", address = FALSE)
}

output$foo <- renderPlot(foo())
output$gino <- renderPrint({
  nearPoints(comp$ComparisonResult, input$pino)
})
output$ginotti <- renderText({
  paste0(input$pinotti$x, input$pinotti$y)
})