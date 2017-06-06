logbuild <- function(x) {
  print(x)
}

# standards name

output$Names <- renderUI({
  selectInput("names", "choose standard", unique(get_data()[1]))
})

# preprocess data
  
preprocess_data = eventReactive(input$run, {
  # logbuild(as.list(c("logTrans"=input$log,
  #                  "normalization"=input$norm,
  #                  "nameStandards"=input$names,
  #                  #                              betweenRunInterferenceScore=input$interf, 
  #                  "fillIncompleteRows"=input$fill,
  #                  "featureSubset"=input$feat,
  #                  "remove_proteins_with_interference"=input$interf,
  #                  "n_top_feature"=input$n_feat,
  #                  "summaryMethod"=input$method,
  #                  "equalFeatureVar"=input$equal,
  #                  "censoredInt"=input$censInt,
  #                  "cutoffCensored"=input$cutoff,
  #                  "MBimpute"=input$MBi,
  #                  "maxQuantileforCensored"=input$maxQC,
  #                  "remove50missing"=input$remove50
  #                  #                             skylineReport=input$report)
  #                  
  # )))
  preprocessed <- dataProcess(raw=get_data(),
                              logTrans=input$log,
                              normalization=input$norm,
                              nameStandards=input$names,
#                              betweenRunInterferenceScore=input$interf, 
                              fillIncompleteRows=input$fill,
                              featureSubset=input$feat,
                              remove_proteins_with_interference=input$interf,
                              n_top_feature=input$n_feat,
                              summaryMethod=input$method,
                              equalFeatureVar=input$equal,
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

plotresult <- function() {

  id <- as.character(UUIDgenerate(FALSE))
  id_address <- paste("tmp/",id, sep = "")
  path = paste("www/", id_address, sep = "")
  
  dataProcessPlots(data = preprocess_data(),
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
                     address = path
    )
  
  return(id_address)
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

output$showplot <- renderUI({
      tags$br()
      tags$br()
      if (input$type == "ProfilePlot") {
        tagList(
          a("Open Plot", href=paste(plotresult(), "ProfilePlot.pdf", sep = ""), target="_blank"),
          tags$br(),
          a("Open Plot with summarization", href=paste(plotresult(),"ProfilePlot_wSummarization.pdf", sep = ""), target="_blank")
        )
      }
      else if (input$type == "ConditionPlot") {
        tagList(
          a("Open Plot", href=paste(plotresult(),"ConditionPlot.pdf", sep = ""), target="_blank")
        )
      }
      else if (input$type == "QCPlot") {
        tagList(
          a("Open Plot", href=paste(plotresult(),"QCPlot.pdf", sep = ""), target="_blank")
        )
      }
    })



