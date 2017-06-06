


statmodel = fluidPage(
  headerPanel("Statistical Model"),
  p("In this tab a statistical model is built.  Create a contrast matrix with the correct comparisons, then verify the model assumptions and view result plots."),
  p("More info ", a("here", href="https://www.rdocumentation.org/packages/MSstats/versions/3.4.0/topics/groupComparisonPlots")),
  tabsetPanel(
    tabPanel("Data Comparison",
             fluidRow(
               column(2,
                      h4("Define comparisons", tipify(icon("question-circle"), title="Choose pairwise comparisons to find significantly expressed proteins")),
                      uiOutput('choice1'),
                      h6("vs"),
                      uiOutput("choice2"),
                      tags$br(),
                      actionButton("submit", "Submit"),
                      tags$br(),
                      tags$br(),
                      actionButton("clear", "Clear matrix")
                      ),
               column(3,
                      h4("Selected comparisons"),
                      textOutput("comparisons"),
                      h5("Comparison matrix"),
                      uiOutput("matrix"),
                      conditionalPanel(condition="$('html').hasClass('shiny-busy')",
                                       tags$br(),
                                       tags$br(),
                                       tags$h4("Calculation in progress...")),
                      conditionalPanel(condition = "input.submit > 0 && !$('html').hasClass('shiny-busy')",
                                       downloadButton("compar", "download table of comparison"),
                                       downloadButton("model_QC", "download table of quality control"),
                                       downloadButton("fitted_v","download fitted linear model summary")
                      )),
               column(4,
                      h4("There are ",textOutput("number", inline = TRUE),"significant proteins"),
                      tags$br(),
                      sliderInput("signif", 
                                  label = h4("Significance level", tipify(icon("question-circle"), title="Probability of rejecting the null hypothesis given that it is true (probability of type I error)")) , 0, 1, 0.05),
                      tags$br(),
                      tableOutput("significant"),
                      downloadButton("download_signif", "Download table of significant proteins"),
                      offset = 2
                      )
             )
             ),
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
               actionButton("plot_assumptions", "Plot QQPlot and Residuals"),
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
             ),
    tabPanel("Results",
             sidebarPanel(
               selectInput("typeplot", 
                           label = h4("Select plot type"), c("Volcano Plot" = "VolcanoPlot", "Heatmap"="Heatmap", "Comparison Plot"="ComparisonPlot")),
               tags$br(),
               numericInput("sig", 
                            label = h4("Significance level"), 0.05, 0, 1 , 0.01),
               tags$br(),
               uiOutput("WhichComp"),
               tags$br(),
               conditionalPanel(condition = "input.typeplot == 'VolcanoPlot' || input.typeplot == 'Heatmap'",
                                checkboxInput("FC1", 
                                              label = h5("Apply specific fold change cutoff for significance")),
                                conditionalPanel(condition = "input.FC1 == true",
                                                 numericInput("FC", "cutoff", 1, 0, 100, 0.1)),
                                tags$br(),
                                selectInput("logp", 
                                            label = h4("Log transformation of adjusted p-value"),
                                            c("base two" = "2", "base ten" = "10"), selected = "base ten")),
               tags$br(),
               conditionalPanel(condition = "input.typeplot == 'VolcanoPlot'",
                              checkboxInput("pname", 
                                            label = h5("display protein name"))),
               conditionalPanel(condition = "input.typeplot == 'Heatmap'",
                                numericInput("nump", "Number of proteins in heatmap", 100, 1, 180, 1)),
               tags$br(),
               selectInput("cluster",
                           label = h4("Cluster analysis", tipify(icon("question-circle"), title= "How to order proteins and comparisons: compute protein dendrogram and reorder based on protein means; compute comparison dendrogram and reorder based on comparison means; or both", placement = "top")), 
                                                                 c("protein dendogram" = "protein", "comparison dendogram" = "comparison", "protein and comparison dendograms" = "both"))
               
             ),
             mainPanel(
               tags$br(),
               tags$br(),
               actionButton("plot_results", "Plot Results"),
               conditionalPanel(condition="$('html').hasClass('shiny-busy')",
                                tags$br(),
                                tags$br(),
                                tags$h4("Calculation in progress...")),
               conditionalPanel(condition = "input$plot_results == TRUE && !$('html').hasClass('shiny-busy')",
                                tags$br(),
                                tags$br(),
                                uiOutput("comparison_plots"))   
             )
    
  )
)
)
