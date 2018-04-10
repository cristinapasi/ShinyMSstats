
######## UI ########

# standards name

output$Names <- renderUI({
  if (input$standards == "Proteins") {
    selectizeInput("names", "choose standard", unique(get_data()[1]), multiple = T)
  }
  else if (input$standards == "Peptides") {
    selectizeInput("names", "choose standard", unique(get_data()[2]), multiple = T)
  }
})

# toggle censoring input based on type of experiment

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

quantile <- function() {
  if (input$null == TRUE) {
    maxQC <- NULL
  }
  else {
    maxQC <- input$maxQC
  }
  return(maxQC)
}

# features

output$features <- renderUI({
  req(get_data())
  max_feat <- reactive ({
    if (nrow(unique(get_data()[1])) < 20) {
      m_feat <- nrow(unique(get_data()[1]))
    }
    else
    {
      m_feat <- 20
      }
    return(m_feat)
  })
  sliderInput("n_feat", "Number of top features to use", 1, as.numeric(max_feat()), 3)
})

observe ({
  shinyjs::toggleState("n_feat", input$all_feat == FALSE)
})

features <- function() {
  if (input$all_feat == FALSE) {
    n_feat <- "topN"
  }
  else {
    n_feat <- "all"
  }
  return(n_feat)
}

# which protein to plot (will add "all" for QCPlot)

output$Which <- renderUI({
  if (input$type == "QCPlot") {
    selectizeInput("which", "Show plot for", choices = c("", "ALL PROTEINS" = "allonly", unique(get_data()[1])))
  }
  else {
    selectizeInput("which", "Show plot for", choices = c("", unique(get_data()[1])))
  }
})

######### functions ########

# preprocess data
  
preprocess_data = eventReactive(input$run, {
  validate(need(get_data(), 
                message = "PLEASE UPLOAD DATASET OR SELECT SAMPLE"))
  preprocessed <- dataProcess(raw=get_data(),
                              logTrans=input$log,
                              normalization=input$norm,
                              nameStandards=input$names,
                              #                              betweenRunInterferenceScore=input$interf, 
                              #                              fillIncompleteRows=input$fill,
                              featureSubset=features(),
                              #                              remove_proteins_with_interference=input$interf,
                              n_top_feature=input$n_feat,
                              summaryMethod="TMP",
                              #                              equalFeatureVar=input$equal,
                              censoredInt=input$censInt,
                              cutoffCensored=input$cutoff,
                              MBimpute=input$MBi,
                              maxQuantileforCensored=quantile(),
                              remove50missing=input$remove50
                              #                             skylineReport=input$report
                              )
  return(preprocessed)
  })

# plot data

plotresult <- function(saveFile, protein, summary, original) {
  if (input$which != "") {
    id <- as.character(UUIDgenerate(FALSE))
    id_address <- paste("tmp/",id, sep = "")
    path <- function()  {
      if (saveFile) {
        path_id = paste("www/", id_address, sep = "")
      } 
      else {
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
                             which.Protein = protein,
                             originalPlot = original,
                             summaryPlot = summary,
                             save_condition_plot_result = FALSE,
                             address = path()
    )
    if (saveFile) {
      return(id_address)
    } 
    else {
      return (plot)
    }
  }
  else {
    return(NULL)
  }
}

# statistics (for ConditionPlot)

statistics <- reactive({
  sub <- preprocess_data()$RunlevelData[which(preprocess_data()$RunlevelData$Protein == input$which),]
  len <- aggregate(sub$LogIntensities~sub$GROUP_ORIGINAL, length, data = sub)
  colnames(len)[colnames(len)=="sub$LogIntensities"] <- "Number_of_Measurements"
  sd <- aggregate(sub$LogIntensities~sub$GROUP_ORIGINAL, sd, data = sub)
  colnames(sd)[colnames(sd)=="sub$LogIntensities"] <- "Standard_Deviation"
  mean <- aggregate(sub$LogIntensities~sub$GROUP_ORIGINAL, mean, data = sub)
  colnames(mean)[colnames(mean)=="sub$LogIntensities"] <- "Mean"
  tab <- merge(len, sd, by="sub$GROUP_ORIGINAL")
  tab <- merge(mean, tab, by="sub$GROUP_ORIGINAL")
  colnames(tab)[colnames(tab)=="sub$GROUP_ORIGINAL"] <- "Condition"
  SE <- tab$Standard_Deviation/sqrt(tab$Number_of_Measurements)
  tab$CI_width <- qt(.975, df=tab$Number_of_Measurement)*SE
  CI_Limits <- c(tab$Mean-tab$CI, tab$Mean+tab$CI)
  
  return(tab)
})


######## output #######


# output preprocessed data

observeEvent(input$run, {
  output$effect <- renderPrint(
    str(preprocess_data())
  )
  insertUI(selector = "#download_buttons",
           where = "afterEnd",
           ui= tags$div(tags$br(),
                        downloadButton("prepr_csv","Download .csv of preprocessed data"),
                        downloadButton("summ_csv","Download .csv of summarised data")
           )
  )
})

# download preprocessed data

output$prepr_csv <- downloadHandler(
  filename = function() {
    paste("Preprocessed_data-", Sys.Date(), ".csv", sep="")
  },
  content = function(file) {
    write.csv(preprocess_data()$ProcessedData, file)
  }
)

output$summ_csv <- downloadHandler(
  filename = function() {
    paste("Summarized_data-", Sys.Date(), ".csv", sep="")
  },
  content = function(file) {
    write.csv(preprocess_data()$RunlevelData, file)
  }
)

# download/view plots

 observeEvent(input$saveone, {
   path <- plotresult(TRUE, input$which, FALSE, TRUE)
   if (input$type == "ProfilePlot") {
     js <- paste("window.open('", path, "ProfilePlot.pdf')", sep="")
     shinyjs::runjs(js);
   }
   else if (input$type == "ConditionPlot") {
     js <- paste("window.open('", path, "ConditionPlot.pdf')", sep="")
     shinyjs::runjs(js);
   }
   else if (input$type == "QCPlot") {
     js <- paste("window.open('", path, "QCPlot.pdf')", sep="")
     shinyjs::runjs(js);
   }
 })
   
 observeEvent(input$saveall, {
   path <- plotresult(TRUE, "all", FALSE, TRUE)
   if (input$type == "ProfilePlot") {
     js <- paste("window.open('", path, "ProfilePlot.pdf')", sep="")
     shinyjs::runjs(js);
   }
   else if (input$type == "ConditionPlot") {
     js <- paste("window.open('", path, "ConditionPlot.pdf')", sep="")
     shinyjs::runjs(js);
   }
   else if (input$type == "QCPlot") {
     js <- paste("window.open('", path, "QCPlot.pdf')", sep="")
     shinyjs::runjs(js);
   }
 })
 
output$showplot <- renderUI({
  tagList(
    plotOutput("theplot"),
    conditionalPanel(condition = "input.type == 'ConditionPlot' && input.which != ''",
                     tableOutput("stats")),
    tags$br(),
    conditionalPanel(condition = "input.which != ''",
                     actionButton("saveone", "Save this plot"),
                     bsTooltip(id = "saveone", title = "Open plot as pdf.  Popups must be enabled", placement = "bottom", trigger = "hover"),
                     actionButton("saveall", "Save all plots"),
                     bsTooltip(id = "saveall", title = "Open pdf of all plots.  Popups must be enabled", placement = "bottom", trigger = "hover")
                     )
    )
})

theplot <- reactive({
  if (input$summ == FALSE) {
    output <- plotresult(FALSE, input$which, FALSE, TRUE)
  }
  else if (input$summ == TRUE) {
    output <- plotresult(FALSE, input$which, TRUE, FALSE)
  } 
  return (output)
})

output$theplot <- renderPlot(theplot())

output$stats <- renderTable(statistics())
