

home = fluidPage(
  headerPanel("Welcome to MSstats-shiny"),
  tags$br(),
  mainPanel(
    div(tagList(
      h4("About MSstats-Shiny"),
      p("This is a web tool for the statistical analysis of quantitative proteomic data.  It is built based on the R package ", a("MSstats (v 3.10.0).", href="http://msstats.org/")),
      p("The full code can be accessed online at ", a("https://github.com/cristinapasi/ShinyMSstats.", href="https://github.com/cristinapasi/ShinyMSstats")),
      br(),
      br()
#      p("There are "),
#      verbatimTextOutput("count"),
#      p("people currently using Shiny-MSstats")
      )
      )
    )
  )
  

