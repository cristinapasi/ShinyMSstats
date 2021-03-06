
library(shiny)
library(shinyBS)
library(shinyjs)
library(STRINGdb)
if (FALSE) require("V8")
library(MSnbase)

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


# shinyjs.disableTab = function() {
#   vartabs = $('tablist').find('li:not(.active) a');
#   tabs.bind('click.tab', function(e) {
#     e.preventDefault();
#     return false;
#   });
#   tabs.addClass('disabled');
# }
# 
# shinyjs.enableTab = function(param) {
#   vartabs = $('tablist').find('li:not(.active):nth-child(' + param + ') a');
#   tab.unbind('click.tab');
#   tab.removeClass('disabled');
# }



 ####################################

source("panels/home-ui.R", local = T)
source("panels/loadpage-ui.R", local = T)
source("panels/qc-ui.R", local = T)
source("panels/pq-ui.R", local = T)
source("panels/statmodel-ui.R", local = T)
source("panels/expdes-ui.R", local = T)
#source("panels/analysis-ui.R", local = T)
#source("panels/clust-ui.R", local = T)
source("panels/report-ui.R", local = T)
source("panels/help-ui.R", local = T)

#########################################################################

jsCode = '
shinyjs.init = function() {
$(document).keypress(function(e) { alert("Key pressed: " + e.which); });
  alert("fooo");
  console.log("initttttt");
  $("#tablist li a").addClass("disabled");

  $(".nav").on("click", ".disabled", function (e) {
    e.preventDefault();
    return false;
  });
}

shinyjs.enableTab = function(value) {
  $("#tablist li a[data-value=" + value + "]").removeClass("disabled");
}
'

css <- "
.disabled {
background: #eee !important;
cursor: default !important;
color: black !important;
}
"

ui <- navbarPage(
  title = "MSstats-Shiny",
  id = "tablist",
  selected = "Homepage",
  
  tags$head(
    tags$style(HTML("
                    .shiny-output-error-validation {
                    color: red;
                    }
                    "))
    ),
  
  useShinyjs(),
  extendShinyjs(text = jsCode),
  tags$style(css),
  
  
  tabPanel("Homepage", icon = icon("home"), home),
  tabPanel("Upload data", icon = icon("send"), loadpage),
  tabPanel("Data Processing", icon = icon("gears"), qc),
  tabPanel("Protein Quantification", icon = icon("calculator"), pq),
  tabPanel("Statistical Model", icon = icon("magic"), statmodel),
#  tabPanel("Functional Analysis", icon = icon("bar-chart"), analysis),
#  tabPanel("Clustering/Classification", icon = icon("puzzle-piece"), clust),
  tabPanel("Future Experiments", icon = icon("flask"), expdes),
  tabPanel("Download Logfile", icon = icon("download"), report),
  tabPanel("Help", icon = icon("ambulance"), help),
  inverse = T,
  collapsible = T,
  windowTitle = "Shiny-MSstats"
)

shinyUI(ui)