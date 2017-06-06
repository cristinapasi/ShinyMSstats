

library(shiny)
library(shinyBS)

source("panels/home-ui.R", local = T)
source("panels/loadpage-ui.R", local = T)
source("panels/qc-ui.R", local = T)
source("panels/statmodel-ui.R", local = T)
source("panels/expdes-ui.R", local = T)
source("panels/analysis-ui.R", local = T)
source("panels/help-ui.R", local = T)

#########################################################################

corner_element = HTML(paste0('<a href=',shQuote(paste0("https://google.com/",">")), '</a>'))

ui <- navbarPage(
  corner_element,
  title = "Shiny-MSstats",
  tabPanel("Homepage", icon = icon("home"), home),
  tabPanel("Load data", icon = icon("send"), loadpage),
  tabPanel("Quality Control", icon = icon("star"), qc),
  tabPanel("Statistical Model", icon = icon("magic"), statmodel),
  tabPanel("Functional Analysis", icon = icon("feed"), analysis),
  tabPanel("Future Experiments", icon = icon("flask"), expdes),
#  tabPanel("Download Report", icon = icon("download"), report),
  tabPanel("Help", icon = icon("ambulance"), help),
  inverse = T,
  collapsible = T,
  windowTitle = "Shiny-MSstats"
)


shinyUI(ui)