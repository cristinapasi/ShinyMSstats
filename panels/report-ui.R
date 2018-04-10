report = fluidPage(
  headerPanel("Analysis logfile"),
  # tags$br(),
  # mainPanel(
  #   div(
  #     tagList(
  #       h4("Data"),
  #       p("This is the report of the analysis performed with MSstats through the Shiny-MSstats online application. www"),
  #       tags$ul(
  #         tags$li("Type of acquisition: ",
  #           textOutput("input1", inline = T)),
  #         tags$li("Type of experiment: ",
  #           textOutput("input2", inline = T))
  #         ),
  #       checkboxInput("output1", "Include summary of data"),
  #       conditionalPanel(condition = "input.output1 == true",
  #                        verbatimTextOutput("output1.1")),
  #       textInput("observations1", "Observations"),
  #       tags$hr(),
  #       h4("Preprocessing and quality control"),
  #       conditionalPanel(condition = "input.run == true",
  #                        p("Data was preprocessed with the following parameters: ")),
  #       tags$ul(
  #         tags$li("Log base data transformation: ",
  #           textOutput("input3", inline = T)),
  #         tags$li("Normalisation: ",
  #           textOutput("input4", inline = T)),
  #         conditionalPanel(condition = "input.norm == 'globalStandards'",
  #                          tags$li(textOutput("input5", inline = T), "standard: ",
  #                                  textOutput("input6", inline = T))
  #         ),
  #         tags$li("Summarization method: TMP"),
  #         conditionalPanel(condition = "input.remove50 == true",
  #                          tags$li("Removed proteins with over 50% missing values")),
  #         tags$li("Assumptions for censored data: ", 
  #                 textOutput("input7", inline = T)),
  #         conditionalPanel(condition = "input.censInt != 'null'",
  #                          tags$li("Cutoff value for censoring: ", 
  #                                  textOutput("input8", inline = T))),
  #         conditionalPanel(condition = "input.null != true",
  #                          tags$li("Max quantile for censored: ",
  #                                  textOutput("input9", inline = T))
  #         ),
  #         conditionalPanel(condition = "input.MBi == true",
  #                          tags$li("Model based imputation")),
  #         tags$li("Number of features used:",
  #                 textOutput("input10", inline = T)),
  #         conditionalPanel(condition = "input.all_feat == false",
  #                          textOutput("input11", inline = TRUE))
  #         ),
  #       tags$br(),
  #       checkboxInput("output2", "Include summary of preprocessed data"),
  #       conditionalPanel(condition = "input.output2 == true",
  #                        verbatimTextOutput("output2.1")),
  #       tags$br(),
  #       p("See tables of preprocessed or summarized data (downloaded from the Quality Control tab)"),
  #       tags$br(),
  #       p("See Profile Plots, Condition Plots and QC Plots (downloaded from the Quality Control tab)"),
  #       textInput("observations2", "Observations"),
  #       tags$hr(),
  #       h4("Statistical model"),
  #       p("The performed comparisons are: ",
  #         textOutput("input12", inline = TRUE)),
  #       checkboxInput("output3", "Include contrast matrix"),
  #       conditionalPanel(condition = "input.output3 == true",
  #                        tableOutput("output3.1")),
  #       p("From the comparison there are ", textOutput("output4", inline = T), "significant proteins at ", textOutput("input13", inline = TRUE), "significance level."),
  #       checkboxInput("output4", "Include full table of significant proteins"),
  #       conditionalPanel(condition = "input.output4 == true",
  #                        tableOutput("output4.1")),
  #       p("See Vulcano Plot, Heatmap and Comparison Plot (downloaded from the Statistical Model tab)."),
  #       tags$br(),
  #       p("Verify model assumptions on the Statistical Model tab (QQ plot and Residual plot)"),
  #       textInput("observations3", "Observations"),
  #       tags$hr(),
  #       h4("Planning future experiments"),
  #       p("See plots to estimate sample size or power (downloaded from the Future Experiment tab)"),
  #       textInput("observations3", "Observations")
  #       ),
  downloadButton("pdf", "Download pdf logfile")
      )
  #   )
  # )


