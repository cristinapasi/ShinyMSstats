sbp_load = sidebarPanel(

  
  # selection for DIA DDA or SRM/PRM
  
  radioButtons("DDA_DIA",
               label = h4("Type of Acquisition", tipify(icon("question-circle"), 
               title = "Select if the acquisition was Data Independent, Data Dependent or Selected/Parallel Reaction Monitoring")),
               c("DDA" = "DDA", "DIA" = "DIA", "SRM/PRM" = "SRM_PRM")),
  
  
  # DDA
  
  # conditionalPanel(
  #   condition = "input.DDA_DIA == 'DDA'",

  radioButtons("filetype",
               label = h4("Type of File", tipify(icon("question-circle"), title = "Choose input type: sample dataset, classical 10-column dataset, or outputs from Skyline, MaxQuant, Progenesis or Proteome Discoverer")),
    choices = c("sample dataset" = "sample", "10 column dataset" = "10col", "Skyline" = "sky", "MaxQuant" = "maxq", "Progenesis" = "prog", "Proteome Discoverer" = "PD", "Spectronaut" = "spec", "OpenSWATH" = "open"), selected = character(0)),
 # ),

  
   
  # DIA
  
  # conditionalPanel(
  #   condition = "input.DDA_DIA == 'DIA'",
  # 
  #   radioButtons(
  #   'filetype', label = h4("Type of File", tipify(icon("question-circle"), title = "Choose input type: sample dataset, classical 10-column dataset, or outputs from Skyline, MaxQuant, Progenesis or Proteome Discoverer")),
  #   choices = c("sample dataset" = "sample2", "10 column dataset" = "10col2", Skyline = "sky2", Spectronaut = "spec", OpenSWATH = "open"), selected = character(0))
  #   ),

 
  
# SRM/PRM

  # conditionalPanel(
  #   condition = "input.DDA_DIA == 'SRM_PRM'",
  # 
  #   radioButtons(
  #   'filetype', label = h4("Type of File", tipify(icon("question-circle"), title = "Choose input type: sample dataset, classical 10-column dataset, or outputs from Skyline, MaxQuant, Progenesis or Proteome Discoverer")),
  #   choices = c("sample dataset" = "sample3", "10 column dataset" = "10col3", "Skyline" = "sky"), selected = character(0))
  #   ),





# upload

h4("Upload dataset file"),

fileInput('data', "", multiple = F, accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")),

radioButtons("sep",
             label = h5("Column separator in uploaded file",tipify(icon("question-circle"), title = "Choose how columns are separated in the uploaded file")),
             c(Comma=",",Semicolon=";", Tab="\t",Pipe="|"), inline = T),
tags$br(),

conditionalPanel(
  condition = "input.filetype == 'sky' || input.filetype == 'maxq' || input.filetype == 'prog' || input.filetype == 'PD'",
  h5("Upload annotation File"),
  fileInput('annot', "", multiple = F, accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")),
  downloadLink("template", "Open annotation file template")
),

tags$br(),

conditionalPanel(
  condition = "input.filetype == 'maxq'",
  h5("Upload evidence File"),
  fileInput('evidence', "", multiple = F, accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")),
  downloadLink("template1", "Open evidence file template")
)

)




loadpage = fluidPage(
  headerPanel("Upload data"),
  p("Use this page to upload your data or choose the sample dataset to explore the application.  For more information on the type of dataset accepted by Shiny-MSstats please click",
    a("here", href="https://bioconductor.org/packages/devel/bioc/vignettes/MSstats/inst/doc/MSstats.html", target="_blank")),
  p("The sample dataset is taken from the publication ",
    a("Mol Cell Proteomics. 2015 Mar; 14(3): 739–749", href = "http://www.mcponline.org/content/14/3/739.long", target="_blank")),
  tags$br(),
  sbp_load,
  column(width = 8,
         h4("Summary of the data"),
         verbatimTextOutput('summary'),
         tags$br(),
         verbatimTextOutput('summary1')
  )
)


