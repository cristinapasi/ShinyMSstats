### sidebar ###

  sbp_params = sidebarPanel(
  
  # transformation
  radioButtons("log", 
               label= h4("STEP 1 - log transformation", tipify(icon("question-circle"), title = "Logarithmic transformation is applied to the Intensities column")), c(log2 = "2", log10 = "10")),
  tags$hr(),
  selectInput("norm", 
              label = h4("STEP 2 - normalisation", tipify(icon("question-circle"), title = "Choose a normalisation method.  For more information visit the Help tab")), c("none" = "FALSE", "equalize medians" = "equalizeMedians", "quantile" = "quantile", "global standards" = "globalStandards"), selected = "equalizeMedians"),
  conditionalPanel(condition = "input.norm == 'globalStandards'",
                   radioButtons("standards", "Choose type of standards", c("Proteins", "Peptides")),
                   uiOutput("Names")
                   
                   
  ),
  tags$hr(),
  
  # summary method
  h4("STEP 3 - summarization", tipify(icon("question-circle"), title = "Run-level summarization method")),
  p("method: TMP"),
  p("For linear summarzation please use command line"),
  
  tags$hr(),
  
  # remove runs with more than 50%missing
  
  checkboxInput("remove50", "remove runs with over 50% missing values"),
  
  tags$hr(),
  
  # censored
  
  h4("STEP 4 - Censored values"),
  radioButtons('censInt', 
              label = h5("Assumptions for censored data", tipify(icon("question-circle"), title = "Processing software report missing values differently; please choose the appropriate options to distinguish missing values and if censored/at random")), c("assume all NA as censored" = "NA", "assume all between 0 and 1 as censored" = "0", "all missing values are random" = "null"), selected = "NA"),
  radioTooltip(id = "censInt", choice = "NA", title = "It assumes that all NAs in Intensity column are censored.", placement = "right", trigger = "hover"),
  radioTooltip(id = "censInt", choice = "0", title = "It assumes that all values between 0 and 1 in Intensity column are censored.  NAs will be considered as random missing.", placement = "right", trigger = "hover"),
  radioTooltip(id = "censInt", choice = "null", title = "It assumes that all missing values are randomly missing.", placement = "right", trigger = "hover"),
  
  # cutoff for censored
  conditionalPanel(condition = "input.censInt == 'NA' || input.censInt == '0'",
                   selectInput("cutoff", "cutoff value for censoring", c("min value per feature"="minFeature", "min value per feature and run"="minFeatureNRun", "min value per run"="minRun"))),
  
  # max quantile for censored
  h5("Max quantile for censored"),
  checkboxInput("null", "NULL"),
  numericInput("maxQC", NULL, 0.999, 0.000, 1.000, 0.001),
  
  # MBi
  conditionalPanel(condition = "input.censInt == 'NA' || input.censInt == '0'",
                   checkboxInput("MBi", 
                                 label = p("Model Based imputation", tipify(icon("question-circle"), title = "If unchecked the values set as cutoff for censored will be used")), value = TRUE
                                 )),
  tags$hr(),
  
  
  # features
  
  h4("STEP 5 - Used features"),
  uiOutput("features"),
  
  # radioButtons("feat", 
  #              label = h4("STEP 5 - Used features", tipify(icon("question-circle"), title = "Use all features or only a subset")), c("all"="all", "top 3"="top3", "top n"="topn")),
  # conditionalPanel(condition = "input.feat == 'top n'",
  #                  numericInput("n_feat", "number of features", 3, 3, 100, 1)),
  
  # interference score
#  checkboxInput("score", "create interference score", value = FALSE),
#  conditionalPanel(condition = "input.score == true",
#                   actionButton("download1", "Download .csv")),
  
actionButton("run", "Run Preprocessing")

  
  
  
)

  
### main panel ###  
  
main = mainPanel(
  
  
  tabsetPanel(
    tabPanel("Preprocessed data", 
             verbatimTextOutput('effect'),
             conditionalPanel(condition="$('html').hasClass('shiny-busy')",
                              tags$br(),
                              tags$br(),
                              tags$h4("Calculation in progress...")),
             tags$div(id='placeholder')),
    tabPanel("Plot", 
             wellPanel(
               selectInput("type",
                           label = h5("Select plot type", tipify(icon("question-circle"), title = "Use Profile Plots to view technical/biological variability and missing values; use Condition Plots to view differences in intensity between conditions; use QC Plots to view differences between runs and to check the effects of normalization")), c("Show Profile plots"="ProfilePlot","Show Condition plot"="ConditionPlot","Show QC plots"="QCPlot")),
               uiOutput("Which"),
               conditionalPanel(condition = "input.type == 'ProfilePlot'",
                                selectInput("fname",  
                                            label = h5("Feature legend", tipify(icon("question-circle"), title = "Print feature level at transition level, peptide level or choose no feature legend")), c("Transition level"="Transition", "Peptide level"="Peptide", "No feature legend"="NA"))
               ),
               conditionalPanel(condition = "input.type == 'ConditionPlot'",
                                checkboxInput("cond_scale", "Scale conditional level at x-axis (unequal space at x-axis)", value = FALSE),
                                radioButtons("interval", "width of error bar", c("use Confidence Interval"="CI", "use Standard Deviation"="SD"))
               ),
               actionButton("goplot", "Plot results in pdf file"),
               actionButton("plothere", "Show plot in browser (only for one protein)"),
               tags$br()
               
             ),
             conditionalPanel(condition="$('html').hasClass('shiny-busy')",
                              tags$br(),
                              tags$br(),
                              tags$h4("Calculation in progress...")),
             tags$div(id = "showplot")
 
             )
    
  )
  
)
  
  
  

########################################################################################

qc = fluidPage(
  headerPanel("Quality control"),
  p("Preprocessing of the data is performed through 5 steps: Log transformation, Normalisation, Feature selection, Imputation for censored missing values, run-level summarisation.  Please choose preprocessing parameters and hit Run."),
  p("More information on the preprocessing step can be found ", 
    a("here", href="https://rdrr.io/bioc/MSstats/man/dataProcess.html", target="_blank")),
  tags$br(),
  sbp_params,
  column(width = 8,
  main
 )
)