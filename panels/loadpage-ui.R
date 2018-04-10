##### sidebar #####

sbp_load = sidebarPanel(
  
  # selection for DIA DDA or SRM/PRM
  
  radioButtons("DDA_DIA",
               label = h4("Type of Acquisition", tipify(icon("question-circle"), 
                                                        title = "Select if the acquisition was Data Independent, Data Dependent or Selected/Parallel Reaction Monitoring")),
               c("DDA" = "DDA", "DIA" = "DIA", "SRM/PRM" = "SRM_PRM")),
  
  # upload  
  
  radioButtons("filetype",
               label = h4("Type of File", tipify(icon("question-circle"), title = "Choose input type: sample dataset, classical 10-column dataset, or outputs from Skyline, MaxQuant, Progenesis or Proteome Discoverer")),
               choices = c("sample dataset" = "sample", "10 column dataset" = "10col", "Skyline" = "sky", "MaxQuant" = "maxq", "Progenesis" = "prog", "Proteome Discoverer" = "PD", "Spectronaut" = "spec", "OpenSWATH" = "open"), selected = character(0)),
  tags$hr(),
  conditionalPanel(condition = "input.filetype =='10col' || input.filetype =='prog' || input.filetype =='PD' || input.filetype =='open'",
                   h4("Upload quantification dataset")),
  conditionalPanel(condition = "input.filetype == 'sky'",
                   h4("Upload MSstats report from Skyline")),
  conditionalPanel(condition = "input.filetype == 'spec'",
                   h4("Upload MSstats scheme output from Spectronaut")),
  conditionalPanel(condition = "input.filetype && input.filetype != 'maxq' && input.filetype != 'sample'",
                   fileInput('data', "", multiple = F, accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")),
                   radioButtons("sep",
                                label = h5("Column separator in uploaded file",tipify(icon("question-circle"), title = "Choose how columns are separated in the uploaded file")),
                                c(Comma=",",Semicolon=";", Tab="\t",Pipe="|"), inline = T)),
  tags$br(),
  conditionalPanel(
    condition = "input.filetype == 'sky' || input.filetype == 'prog' || input.filetype == 'PD' || input.filetype == 'spec' || input.filetype == 'open'",
    h4("Upload annotation File"),
    fileInput('annot', "", multiple = F, accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")),
    downloadLink("template", "Open annotation file template")
  ),
  tags$br(),
  conditionalPanel(
    condition = "input.filetype == 'maxq'",
    h4("Upload evidence.txt File"),
    fileInput('evidence', "", multiple = F, accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")),
    h4("Upload proteinGroups.txt File"),
    fileInput('pGroup', "", multiple = F, accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")),
    h4("Upload annotation File"),
    fileInput('annot', "", multiple = F, accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv"))
  ),
  tags$hr(),
  conditionalPanel(condition = "input.filetype && input.DDA_DIA == 'DDA' && input.filetype !== 'sample'",
                   checkboxInput("remove", "Remove proteins with 1 peptide and charge", value = FALSE)),
  conditionalPanel(condition = "input.filetype && input.DDA_DIA == 'DIA' && input.filetype !== 'sample'",
                   checkboxInput("remove", "Remove proteins with 1 feature", value = FALSE),
                   conditionalPanel(condition = "input.filetype == 'sky' || input.filetype == 'spec'",
                                    checkboxInput("q_val", "Filter with Q-value"),
                                    conditionalPanel(condition = "input.q_val",
                                                     numericInput("q_cutoff", "Q-value cutoff", 0.01, 0, 1, 0.01))),
                   conditionalPanel(condition = "input.filetype == 'open'",
                                    checkboxInput("m_score", "Filter with M-score"),
                                    conditionalPanel(condition = "input.m_score",
                                                     numericInput("m_cutoff", "M-score cutoff", 0.01, 0, 1, 0.01)))
  )
)

##########################################

loadpage = fluidPage(
  headerPanel("Upload data"),
  p("Use this page to upload your data or choose the sample dataset to explore the application.  For more information on the type of dataset accepted by Shiny-MSstats please click",
    a("here", href="https://bioconductor.org/packages/devel/bioc/vignettes/MSstats/inst/doc/MSstats.html", target="_blank")),
  tags$br(),
  conditionalPanel(
    condition = "input.filetype == 'sample' && input.DDA_DIA == 'DDA'",
    p("The sample dataset for DDA acquisition is on its way ")
  ),
  conditionalPanel(
    condition = "input.filetype == 'sample' && input.DDA_DIA == 'DIA'",
    p("The sample dataset for DIA acquisition is taken from the publication ",
    a("Selevsek, N. et al. Reproducible and Consistent Quantification of the Saccharomyces Cerevisiae Proteome by SWATH-Mass Spectrometry. Molecular & Cellular Proteomics : MCP 14.3 (2015): 739–749. ", href = "http://www.mcponline.org/content/14/3/739.long", target="_blank"))
  ),
  conditionalPanel(
    condition = "input.filetype == 'sample' && input.DDA_DIA == 'SRM_PRM'",
    p("The sample dataset for SRM/PRM acquisition is taken from the publication ",
    a("Picotti, P. et al. Full dynamic range proteome analysis of S. cerevisiae by targeted proteomics. Cell (2009), 138, 795–806.", href = "http://www.cell.com/cell/fulltext/S0092-8674(09)00715-6", target="_blank"))
  ),
  tags$br(),
  sbp_load,
  column(width = 8,
         h4("Summary of the data"),
         conditionalPanel(condition="$('html').hasClass('shiny-busy')",
                          tags$br(),
                          tags$h4("Calculation in progress...")),
         verbatimTextOutput('summary'),
         tags$br(),
         verbatimTextOutput('summary1')
  )
)



