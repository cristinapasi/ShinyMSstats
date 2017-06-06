expdes = fluidPage(
  shinyjs::useShinyjs(),
  headerPanel("Design Future Experiments"),
  sidebarPanel(
    h4("Choose parameter to estimate"),
    radioButtons("param", "parameters:", c("Sample Size" = "sample", "Power" = "npower")),
    sliderInput("nsample", "Number of samples", 0,1000,4,1),
    sliderInput("power", "Power", 0,1,0.8,0.1),
    sliderInput("FDR", "False Dicovery Rate", 0,1,0.05, 0.01),
    sliderInput("desirFC", "Desired Fold Change", -10, 10, c(1.25, 1.75), 0.01)
  ),
  mainPanel(
    h4("Plot"),
    plotOutput("result_plot", hover = "plot_hover"),
    verbatimTextOutput("info"),
    downloadButton("download_future", "Download plot")
  )
)
    
         


