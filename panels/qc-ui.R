### sidebar ###

  sbp_params = sidebarPanel(
  
  # transformation
  radioButtons("log", 
               label= h4("STEP 1 - log transformation", tipify(icon("question-circle"), title = "Logarithmic transformation is applied to the Intensities column")), c(log2 = "2", log10 = "10")),
  tags$hr(),
  selectInput("norm", 
              label = h4("STEP 2 - normalisation", tipify(icon("question-circle"), title = "Choose a normalisation method.  For more information visit the Help tab")), c("none" = "FALSE", "equalize medians" = "equalizeMedians", "quantile" = "quantile", "global standards" = "globalStandards"), selected = "equalizeMedians"),
  conditionalPanel(condition = "input.norm == 'globalStandards'",
                   uiOutput("Names")
                   
                   
  ),
  tags$hr(),
  
  # summary method
  radioButtons("method", 
               label = h4("STEP 3 - summarization", tipify(icon("question-circle"), title = "Run-level summarization method")), c("TMP" = "TMP", "linear" = "linear")),
  tags$hr(),
  
  # equal var
  conditionalPanel(condition = "input.method == 'linear'",
                   checkboxInput("equal", "do not assume equal variance among intensities")),
  
  # remove runs with more than 50%missing
  conditionalPanel(condition = "input.method == 'tmp'",
                   checkboxInput("remove50", "remove runs with over 50% missing values")),
  tags$hr(),
  
  # censored
  selectInput('censInt', 
              label = h4("STEP 4 - Censored values", tipify(icon("question-circle"), title = "Processing software report missing values differently; please choose the appropriate options to distinguish missing values and if censored/at random")), c("assume all NA as censored" = "NA", "assume all between 0 and 1 as censored" = "0", "all missing values are random" = "null"), selected = "NA"),
  
  # cutoff for censored
  conditionalPanel(condition = "input.censInt == 'NA' || input.censInt == '0'",
                   selectInput("cutoff", "cutoff value for censoring (per feature)", c("min value"="minFeature", "smallest between min value and min run"="minFeatureNRun", "min run"="minRun"))),
  
  # max quantile for censored
  numericInput("maxQC", "max quantile for censored", 0.99, 0.00, 1.00, 0.01),
  
  # MBi
  conditionalPanel(condition = "input.method == 'TMP' && (input.censInt == 'NA' || input.censInt == '0')",
                   checkboxInput("MBi", "impute with cutoff values", value = TRUE)),
  tags$hr(),
  
  
  # features
  radioButtons("feat", 
               label = h4("STEP 5 - Used features", tipify(icon("question-circle"), title = "Use all features or only a subset")), c("all"="all", "top 3"="top3", "top n"="topn")),
  conditionalPanel(condition = "input.feat == 'top n'",
                   numericInput("n_feat", "number of features", 3, 3, 100, 1)),
  
  # interference score
#  checkboxInput("score", "create interference score", value = FALSE),
#  conditionalPanel(condition = "input.score == true",
#                   actionButton("download1", "Download .csv")),
  
  # fill incomplete rows
  checkboxInput("fill", "fill incomplete rows", value = TRUE),
  
  # remove proteins with interference
  checkboxInput("interf", "remove proteins with interference", value = FALSE),

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
             tags$br(),
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
             actionButton("goplot", "Plot results"),
             tags$br(),
             conditionalPanel(condition="$('html').hasClass('shiny-busy')",
                              tags$br(),
                              tags$br(),
                              tags$h4("Calculation in progress...")),
             conditionalPanel(condition = "input.goplot > 0",
                              tags$br(),
                              tags$br(),
                              uiOutput("showplot")
    )

             
             
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
  #  fluidRow(column(width = 12,
  #                  includeMarkdown(""))
  
  #  )
)
