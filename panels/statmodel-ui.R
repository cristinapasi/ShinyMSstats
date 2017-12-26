
statmodel = fluidPage(
  headerPanel("Statistical Model"),
  p("In this tab a statistical model is built.  Create a contrast matrix with the correct comparisons, then verify the model assumptions and view result plots."),
  p("More info ", a("here", href="https://www.rdocumentation.org/packages/MSstats/versions/3.4.0/topics/groupComparisonPlots")),
  tabsetPanel(
    
# statistical model
    
    tabPanel("Data Comparison",
             
# comparison matrix              
             wellPanel(
               fluidRow(
                 column(12,
                        h3("STEP 1 - Define comparisons", tipify(icon("question-circle"), title="Choose pairwise comparisons to find significantly expressed proteins")),
                        fluidRow(
                          column(6,
                                 radioButtons("def_comp", "Define contrast matrix", c("All possible pairwise comparisons" = "all_pair", "Compare all against one" = "all_one", "Create custom comparisons" = "custom"), selected = character(0)),
                                 conditionalPanel(condition = "input.def_comp == 'custom'",
                                                  uiOutput('choice1'),
                                                  h6("vs"),
                                                  uiOutput("choice2"),
                                                  actionButton("submit", "Submit"),
                                                  actionButton("clear", "Clear matrix")
                                                  ),
                                 conditionalPanel(condition = "input.def_comp == 'all_one'",
                                                  h5("Compare all groups against:"),
                                                  uiOutput("choice3"),
                                                  actionButton("submit1", "Submit"),
                                                  actionButton("clear1", "Clear matrix")
                                                  ),
                                 conditionalPanel(condition = "input.def_comp == 'all_pair'",
                                                  actionButton("submit2", "Submit"),
                                                  actionButton("clear2", "Clear matrix")
                                                  )
                                 ),
                          column(6,
                                 sliderInput("signif", 
                                             label = h4("Significance level", tipify(icon("question-circle"), title="Probability of rejecting the null hypothesis given that it is true (probability of type I error)")) , 0, 1, 0.05),
                                 uiOutput("matrix")
                          )
                        )
                 )
               )
               ),

# table of significant proteins 
             wellPanel(
               fluidRow(
                 column(12,
                        h3("STEP 2 - View table of results"),
                        actionButton("calculate", "Calculate comparison")
                 )
               )
               ),
             conditionalPanel(condition="$('html').hasClass('shiny-busy')",
                              tags$br(),
                              tags$h4("Calculation in progress (it may take a while)...")),
             tags$br(),
             uiOutput("table_results"),
             tags$br(),

# plot of results
             wellPanel(
               fluidRow(
                 column(12,
                        h3("STEP 3 - Plot results"),
                                         fluidRow(
                                           column(4,
                                                  selectInput("typeplot", 
                                                              label = h4("Select plot type"), c("Volcano Plot" = "VolcanoPlot", "Heatmap"="Heatmap", "Comparison Plot"="ComparisonPlot")),
                                                  tags$br(),
                                                  numericInput("sig", 
                                                               label = h4("Significance level"), 0.05, 0, 1 , 0.01)),
                                           column(4,
                                                  tags$br(),
                                                  conditionalPanel(condition = "input.typeplot == 'VolcanoPlot'",
                                                                   uiOutput("WhichComp")),
                                                   conditionalPanel(condition = "input.typeplot == 'ComparisonPlot'",
                                                                    uiOutput("WhichProt")),
                                                  tags$br(),
                                                  conditionalPanel(condition = "input.typeplot == 'VolcanoPlot' || input.typeplot == 'Heatmap'",
                                                                   checkboxInput("FC1", 
                                                                                 label = h5("Apply specific fold change cutoff for significance")),
                                                                   conditionalPanel(condition = "input.FC1 == true",
                                                                                    numericInput("FC", "cutoff", 1, 0, 100, 0.1)),
                                                                   tags$br(),
                                                                   selectInput("logp", 
                                                                               label = h4("Log transformation of adjusted p-value"),
                                                                               c("base two" = "2", "base ten" = "10"), selected = "10"))
                                                  ),
                                           column(4,
                                                  tags$br(),
                                                  conditionalPanel(condition = "input.typeplot == 'Heatmap'",
                                                                   numericInput("nump", "Number of proteins in heatmap", 100, 1, 180, 1),
                                                                   selectInput("cluster",
                                                                               label = h5("Cluster analysis", tipify(icon("question-circle"), 
                                                                                                                     title= "How to order proteins and comparisons: compute protein dendrogram and reorder based on protein means; compute comparison dendrogram and reorder based on comparison means; or both", 
                                                                                                                     placement = "top")), 
                                                                               c("protein dendogram" = "protein", "comparison dendogram" = "comparison", "protein and comparison dendograms" = "both"))),
                                                  conditionalPanel(condition = "input.typeplot == 'VolcanoPlot'",
                                                                   checkboxInput("pname", 
                                                                                 label = h5("display protein name")))
                                                  )
                                         ),
                        actionButton("plotresults", "Save Plot Results as pdf"),
                        actionButton("viewresults", "View Plot in browser (only for one comparison/protein)")
                 )
               )
             ),
             fluidRow(
               column(12,tags$br(),
                      tags$br(),
                      
                      conditionalPanel(condition="$('html').hasClass('shiny-busy')",
                                       tags$br(),
                                       tags$br(),
                                       tags$h4("Calculation in progress...")),
                      tags$br(),
                      tags$br(),
                      uiOutput("comparison_plots")
#                      sliderInput("height", "Plot height", value = 400, min = 100, max = 1000, post = "px")
                      )
          
               
             )
    ),
    
# model assumptions    
    
    tabPanel("Verify Model Assumptions",
             fluidRow(
               tags$br(),
               p("The fitted linear model relies on two assumptions:"),
               tags$br(),
               tags$ul(
                 tags$li("the measurement errors must have a Normal distribution"),
                 tags$li("the variance of the errors must be constant")
                 ),
               tags$br(),
               p("These assumptions can be verified by visualising the QQPlots and the Residual Plots for the model."),
               p("View documentation ", a("here", href="https://www.rdocumentation.org/packages/MSstats/versions/3.4.0/topics/modelBasedQCPlots")),
               tags$br(),
               tags$br(),
               radioButtons("assum_type", "Choose plot type", c("QQPlots" = "QQPlots", "ResidualPlots" = "ResidualPlots")),
               uiOutput("WhichProt1"),
               conditionalPanel(condition="$('html').hasClass('shiny-busy')",
                                tags$br(),
                                tags$br(),
                                tags$h4("Calculation in progress..."))
               ),
             fluidRow(
               tags$br(),
               tags$br(),
               uiOutput("verify")
             )
             )
    
)
)

