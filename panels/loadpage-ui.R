sbp_load = sidebarPanel(

  
  # selection for DIA or DDA
  
  radioButtons("DDA_DIA", 
               label = h4("Type of Acquisition", tipify(icon("question-circle"), title = "Select if the acquisition was Data Independent or Data Dependent")), 
    c(DDA = "DDA", DIA = "DIA")),
  
  
  # DDA
  
  conditionalPanel(
    condition = "input.DDA_DIA == 'DDA'",
    
    
  # selection for file type
  
  radioButtons("filetype", 
               label = h4("Type of File", tipify(icon("question-circle"), title = "Choose input type: sample dataset, classical 10-column dataset, or outputs from Skyline, MaxQuant, Progenesis or Proteome Discoverer")), 
    c("sample dataset" = "sample", "classic" = "10col", "Skyline" = "sky", "MaxQuant" = "maxq", "Progenesis" = "prog", "Proteome Discoverer" = "PD")),
  
  tags$br(),
  
  # upload
  
  h4("Upload dataset file"),
  fileInput('data', "", multiple = F, accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")),
  
  radioButtons("sep", 
               label = h5("Column separator in uploaded file",tipify(icon("question-circle"), title = "Choose how columns are separated in the uploaded file")), 
               c(Comma=",",Semicolon=";", Tab="\t",Pipe="|"), inline = T),
  
  h6("Upload annotation File - only for Skyline, MaxQuant, Progenesis, Proteome Discoverer"),
  fileInput('annot', "", multiple = F, accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")),
  
  h6("Upload evidence File - only for MaxQuant"),
  fileInput('evidence', "", multiple = F, accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv"))
  
  ),

  
   
  # DIA
  
  conditionalPanel(
    condition = "input.DDA_DIA == 'DIA'",

  radioButtons(
    'filetype', "Type of File", 
    c(classic = "10col", Skyline = "sky", Spectronaut = "spec", OpenSWATH = "open")),
    
  # upload
  
  h5("Upload dataset file"),
  fileInput('data', "", multiple = F, accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")),
  
  h6("Upload annotation File - only OpenSWATH"),
  fileInput('annot', "", multiple = F, accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv"))
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
  #  fluidRow(column(width = 12,
  #                  includeMarkdown(""))
  
  #  )
)

