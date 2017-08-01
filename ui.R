

library(shiny)
library(shinyBS)

#####################################

# Global functions #

radioTooltip <- function(id, choice, title, placement = "bottom", trigger = "hover", options = NULL){
  
  options = shinyBS:::buildTooltipOrPopoverOptionsList(title, placement, trigger, options)
  options = paste0("{'", paste(names(options), options, sep = "': '", collapse = "', '"), "'}")
  bsTag <- shiny::tags$script(shiny::HTML(paste0("
                                                 $(document).ready(function() {
                                                 setTimeout(function() {
                                                 $('input', $('#", id, "')).each(function(){
                                                 if(this.getAttribute('value') == '", choice, "') {
                                                 opts = $.extend(", options, ", {html: true});
                                                 $(this.parentElement).tooltip('destroy');
                                                 $(this.parentElement).tooltip(opts);
                                                 }
                                                 })
                                                 }, 500)
                                                 });
                                                 ")))
  htmltools::attachDependencies(bsTag, shinyBS:::shinyBSDep)
}


 ####################################

source("panels/home-ui.R", local = T)
source("panels/loadpage-ui.R", local = T)
source("panels/qc-ui.R", local = T)
source("panels/statmodel-ui.R", local = T)
source("panels/expdes-ui.R", local = T)
#source("panels/analysis-ui.R", local = T)
source("panels/help-ui.R", local = T)

#########################################################################


ui <- navbarPage(
  title = "Shiny-MSstats",
  tabPanel("Homepage", icon = icon("home"), home),
  tabPanel("Load data", icon = icon("send"), loadpage),
  tabPanel("Quality Control", icon = icon("star"), qc),
  tabPanel("Statistical Model", icon = icon("magic"), statmodel),
#  tabPanel("Functional Analysis", icon = icon("feed"), analysis),
  tabPanel("Future Experiments", icon = icon("flask"), expdes),
#  tabPanel("Download Report", icon = icon("download"), report),
  tabPanel("Help", icon = icon("ambulance"), help),
  inverse = T,
  collapsible = T,
  windowTitle = "Shiny-MSstats"
)


shinyUI(ui)