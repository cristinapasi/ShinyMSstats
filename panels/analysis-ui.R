side = sidebarPanel(
  tabsetPanel(
    tabPanel("Abundance",
             h4("Download summary of protein abundance", tipify(icon("question-circle"), title="Model-based quantification for each condition or for each biological samples per protein in a targeted Selected Reaction Monitoring (SRM), Data-Dependent Acquisition (DDA or shotgun), and Data-Independent Acquisition (DIA or SWATH-MS) experiment. ")),
             radioButtons("typequant", 
                          label = h4("Type of summarisation"), 
                          c("Sample-level summarisation" = "Sample", "Group-level summarisation" = "Group")),
             radioButtons("format", "Save as", c("matrix" = "matrix", "array" = "long")),
             downloadButton("download_summary", "Download")
    ),
    tabPanel("Annotation",
             h4("Functional analysis"),
             tags$br(),
             h4("Select species", tipify(icon("question-circle"), title = "Select species to access database on Ensembl")),
             uiOutput("Species"),
             tags$br(),
             h4("Select input type", tipify(icon("question-circle"), title = "Select id type for proteins in dataset")),
             uiOutput("Filter"),
             tags$br(),
             h4("Select attributes to retreive", tipify(icon("question-circle"),title = "Select query output, multiple selections are allowed")),
             h5("es. go_id, goslim_goa_description etc"),
             uiOutput("Attributes"),
             downloadButton("table_annot", "Download table of annotations")
    )
  )
)

main_p = mainPanel(
  h4("Table of annotation"),
  tableOutput("annotation")
  
)


##############################################################

analysis = fluidPage(
  headerPanel("Functional analysis"),
  p("Download summary of protein abundance or perform queries to ", a("Ensembl", href="http://www.ensembl.org/index.html"), "."),
  tags$br(),
  side,
  main_p
)