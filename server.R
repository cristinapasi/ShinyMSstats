
library(shiny)
library(MSstats)
library(shinyBS)
library(uuid)
library(shinyjs)
library(biomaRt)
library(Biobase)

###### global functions ###########

xy_str <- function(e) {
  if(is.null(e)) return("NULL\n")
  paste0("x=", round(e$x, 1), " y=", round(e$y, 1), "\n")
}

#####################################################


shinyServer(function(input, output, session) {
  session$allowReconnect(TRUE)
  # load data
  source("panels/loadpage-server.R", local = T)
  # quality control
  source("panels/qc-server.R", local = T)
  # statistical model
  source("panels/statmodel-server.R", local = T)
  # functional analysis
#  source("panels/analysis-server.R", local = T)
  # future experiment
  source("panels/expdes-server.R", local = T)
  # report
  source("panels/report-server.R", local = T)

}
)

