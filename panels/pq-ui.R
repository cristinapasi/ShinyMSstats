main = mainPanel(
  tabsetPanel(
    tabPanel("Protein Quantification",
             fluidRow(
               column(5,
                      wellPanel(
                        fluidRow(
                          h4("Download summary of protein abundance", tipify(icon("question-circle"), title="Model-based quantification for each condition or for each biological samples per protein. ")),
                          radioButtons("typequant", 
                                       label = h4("Type of summarisation"), 
                                       c("Sample-level summarisation" = "Sample", "Group-level summarisation" = "Group")),
                          radioButtons("format", "Save as", c("matrix" = "matrix", "array" = "long")),
                          downloadButton("download_summary", "Download")
                        )
                      )
               ),
               column(7,
                      h4("Table of abundance"),
                      dataTableOutput("abundance")
               )
             )
    )
  )
)

pq = fluidPage(
  headerPanel("Protein Quantification"),
  p("Quantification of the proteins after preprocessing."),
  p("PLEASE PREPROCESS DATA TO COMPLETE THIS STEP"),
  tags$br(),
  main
)
