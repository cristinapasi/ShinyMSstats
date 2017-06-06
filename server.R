
library(shiny)
library(MSstats)
library(shinyBS)
library(uuid)
library(shinyjs)
library(biomaRt)
library(Biobase)


shinyServer(function(input, output, session) {
  session$allowReconnect(TRUE)
  # load data
  source("panels/loadpage-server.R", local = T)
  # quality control
  source("panels/qc-server.R", local = T)
  # statistical model
  source("panels/statmodel-server.R", local = T)
  # functional analysis
  source("panels/analysis-server.R", local = T)
  # future experiment
  source("panels/expdes-server.R", local = T) 
})
