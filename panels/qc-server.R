

# standards name

output$Names <- renderUI({
  if (input$standards == "Proteins") {
    selectizeInput("names", "choose standard", unique(get_data()[1]), multiple = T)
  }
  else if (input$standards == "Peptides") {
    selectizeInput("names", "choose standard", unique(get_data()[2]), multiple = T)
  }
})

observe({
  if(!is.null(input$filetype)) {
    shinyjs::runjs("$('[type=radio][name=censInt]:disabled').parent().parent().parent().find('div.radio').css('opacity', 1)")
    shinyjs::enable("censInt")
    if (input$filetype == "sky" || input$filetype == "prog" || input$filetype == "spec") {
      shinyjs::disable(selector = "[type=radio][value=NA]")
      shinyjs::runjs("$.each($('[type=radio][name=censInt]:disabled'), function(_, e){ $(e).parent().parent().css('opacity', 0.4) })")
    }
    else if (input$filetype == "maxq" || input$filetype == "PD" || input$filetype == "open") {
      shinyjs::disable(selector = "[type=radio][value=0]")
      shinyjs::runjs("$.each($('[type=radio][name=censInt]:disabled'), function(_, e){ $(e).parent().parent().css('opacity', 0.4) })")
    }
  }
})

observe ({
    shinyjs::toggleState("maxQC", input$null == FALSE)
})

output$features <- renderUI({
  req(get_data())
  max_feat <- nrow(unique(get_data()[1]))
  sliderInput("n_feat", "Number of top features", 1, as.numeric(max_feat), 3)
  
}
  
)


# preprocess data
  
preprocess_data = eventReactive(input$run, {

  preprocessed <- dataProcess(raw=get_data(),
                              logTrans=input$log,
                              normalization=input$norm,
                              nameStandards=input$names,
#                              betweenRunInterferenceScore=input$interf, 
#                              fillIncompleteRows=input$fill,
                              featureSubset="topN",
#                              remove_proteins_with_interference=input$interf,
                              n_top_feature=input$n_feat,
                              summaryMethod="TMP",
#                              equalFeatureVar=input$equal,
                              censoredInt=input$censInt,
                              cutoffCensored=input$cutoff,
                              MBimpute=input$MBi,
                              maxQuantileforCensored=input$maxQC,
                              remove50missing=input$remove50
 #                             skylineReport=input$report
)
  return(preprocessed)
  
})

# output preprocessed data

observeEvent(input$run, {
   output$effect <- renderPrint(

     str(preprocess_data())
 
 )
  
  insertUI(selector = "#placeholder",
           where = "afterEnd",
            ui= tags$div(tags$br(),
                         downloadButton("prepr_csv","Download .csv of preprocessed data"),
                         downloadButton("summ_csv","Download .csv of summarised data")
                         )
  )
  })

# plots
observeEvent(input$goplot, {
  plotresult(TRUE)  
})

observeEvent(input$plothere, {
  plotresult(FALSE)  
})

plotresult <- function(saveFile) {

  id <- as.character(UUIDgenerate(FALSE))
  id_address <- paste("tmp/",id, sep = "")
  
  path <- function()  {
    if (saveFile) {
      path_id = paste("www/", id_address, sep = "")
    } else {
      path_id = FALSE
    }
    return (path_id)
  }
  
  plot <- dataProcessPlots(data = preprocess_data(),
                     type=input$type,
                     featureName = input$fname,
                     ylimUp = F,
                     ylimDown = F,
                     scale = input$cond_scale,
                     interval = input$interval,
                     #              x.axis.size = input_xsize,
                     #              y.axis.size = input_ysize,
                     #              t.axis.size = input_tsize,
                     #              text.angle = input_tangle,
                     #              legend.size = input_legend,
                     #              dot.size.profile = input_dot_prof,
                     #              dot.size.condition = input_dot_cond,
                     #              width = input_width,
                     #              height = input_height,
                     which.Protein = input$which,
                     originalPlot = TRUE,
                     summaryPlot = TRUE,
                     save_condition_plot_result = FALSE,
                     address = path()
    )
  if (saveFile) {
    return(id_address)
  } else {
    return (plot)
  }
}
  




# download preprocessed data

output$prepr_csv <- downloadHandler(
  filename = function() {
    paste("data-", Sys.Date(), ".csv", sep="")
  },
  content = function(file) {
    write.csv(preprocess_data()$ProcessedData, file)
  }
)

output$summ_csv <- downloadHandler(
  filename = function() {
    paste("data-", Sys.Date(), ".csv", sep="")
  },
  content = function(file) {
    write.csv(preprocess_data()$RunlevelData, file)
  }
)

# which protein to plot

output$Which <- renderUI({
  selectInput("which", "Select protein or show all", c("all", unique(get_data()[1])))
  })

# download plots


 observeEvent(input$goplot, {
   insertUI(
     selector = "#showplot",
     ui = tags$div(
      if (input$type == "ProfilePlot") {
        tagList(
          a("Open Plot", href=paste(plotresult(TRUE), "ProfilePlot.pdf", sep = ""), target="_blank"),
          tags$br(),
          a("Open Plot with summarization", href=paste(plotresult(TRUE),"ProfilePlot_wSummarization.pdf", sep = ""), target="_blank")
        )
      }
      else if (input$type == "ConditionPlot") {
        tagList(
          a("Open Plot", href=paste(plotresult(TRUE),"ConditionPlot.pdf", sep = ""), target="_blank")
        )
      }
      else if (input$type == "QCPlot") {
        tagList(
          a("Open Plot", href=paste(plotresult(TRUE),"QCPlot.pdf", sep = ""), target="_blank")
        )
      }
     )
   )
  })
 
observeEvent(input$plothere, {
  insertUI(
    selector = "#showplot",
    ui = tags$div(
    plotOutput("plot_here", hover = "hover1"),
    verbatimTextOutput("info1")
    )
  )
  })
    
output$plot_here <- renderPlot(plotresult(FALSE))

output$info1 <- renderText({
  xy_str <- function(e) {
    if(is.null(e)) return("NULL\n")
    paste0("x=", round(e$x, 1), " y=", round(e$y, 1), "\n")
  }
  paste0(
    "hover: ", xy_str(input$hover1)
  )
  
})


