### sidebar ###

sbp_params = sidebarPanel(
  
  # transformation
  
  radioButtons("log", 
               label= h4("Log transformation", tipify(icon("question-circle"), title = "Logarithmic transformation is applied to the Intensities column")), c(log2 = "2", log10 = "10")),
  tags$hr(),
  
  #normalisation
  
  selectInput("norm", 
              label = h4("Normalisation", tipify(icon("question-circle"), title = "Choose a normalisation method.  For more information visit the Help tab")), c("none" = "FALSE", "equalize medians" = "equalizeMedians", "quantile" = "quantile", "global standards" = "globalStandards"), selected = "equalizeMedians"),
  conditionalPanel(condition = "input.norm == 'globalStandards'",
                   radioButtons("standards", "Choose type of standards", c("Proteins", "Peptides")),
                   uiOutput("Names")
  ),
  tags$hr(),
  
  # features
  
  h4("Used features"),
  checkboxInput("all_feat", "Use all features", value = TRUE),
  uiOutput("features"),
  tags$hr(),
  
  ### censoring
  
  h4("Censored values"),
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
  checkboxInput("null", "Do not apply censored cutoff"),
  numericInput("maxQC", NULL, 0.999, 0.000, 1.000, 0.001),
  
  # MBi
  conditionalPanel(condition = "input.censInt == 'NA' || input.censInt == '0'",
                   checkboxInput("MBi", 
                                 label = p("Model Based imputation", tipify(icon("question-circle"), title = "If unchecked the values set as cutoff for censored will be used")), value = TRUE
                                 )),
  tags$hr(),
  
  ### summary method
  
  h4("Summarization", tipify(icon("question-circle"), title = "Run-level summarization method")),
  p("method: TMP"),
  p("For linear summarzation please use command line"),
  tags$hr(),
  
  # remove features with more than 50% missing 
  checkboxInput("remove50", "remove runs with over 50% missing values"),
  tags$hr(),
  
  
  # run 
  
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
             tags$div(id='download_buttons')),
    tabPanel("Plot", 
             wellPanel(
               p("Please preprocess data to view quality control plots"),
               selectInput("type",
                           label = h5("Select plot type", tipify(icon("question-circle"), title = "Use Profile Plots to view technical/biological variability and missing values; use Condition Plots to view differences in intensity between conditions; use QC Plots to view differences between runs and to check the effects of normalization")), c("Show QC plots"="QCPlot", "Show Profile plots"="ProfilePlot","Show Condition plot"="ConditionPlot")),
               conditionalPanel(condition = "input.type == 'ProfilePlot'",
                                checkboxInput("summ", "Show plot with summary"),
                                selectInput("fname",  
                                            label = h5("Feature legend", tipify(icon("question-circle"), title = "Print feature level at transition level, peptide level or choose no feature legend")), c("Transition level"="Transition", "Peptide level"="Peptide", "No feature legend"="NA"))
               ),
               conditionalPanel(condition = "input.type == 'ConditionPlot'",
                                checkboxInput("cond_scale", "Scale conditional level at x-axis (unequal space at x-axis)", value = FALSE),
                                radioButtons("interval", "width of error bar", c("use Confidence Interval"="CI", "use Standard Deviation"="SD"))
               ),
               uiOutput("Which"),
               tags$br()
             ),
             conditionalPanel(condition="$('html').hasClass('shiny-busy')",
                              tags$br(),
                              tags$br(),
                              tags$h4("Calculation in progress...")),
             uiOutput("showplot")
             )
  )
)
  
  
  

########################################################################################

qc = fluidPage(
  headerPanel("Data Processing"),
  p("Preprocessing of the data is performed through: (i) Log transformation, (ii) Normalisation, (iii) Feature selection, (iv) Imputation for censored missing values, (v) Run-level summarisation.  Please choose preprocessing parameters and hit Run.  More information on the preprocessing step can be found ", 
    a("here", href="https://rdrr.io/bioc/MSstats/man/dataProcess.html", target="_blank")),
  p("Quality of data and preprocessing can be assessed in the plot tab of the main panel."),
  p("Preprocessed data will be used for protein quantification and to build a statistical model to evaluate the changes in protein expression."),
  p("PLEASE UPLOAD DATASET OR SELECT SAMPLE DATASET TO COMPLETE THIS STEP"),
  tags$br(),
  sbp_params,
  column(width = 8,
  main
 )
)