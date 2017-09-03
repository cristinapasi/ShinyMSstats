# toggle ui (DDA DIA SRM)

observe({
  if (input$DDA_DIA == "DDA") {
    shinyjs::runjs("$('[type=radio][name=filetype]:disabled').parent().parent().parent().find('div.radio').css('opacity', 1)")
    shinyjs::enable("filetype")
    shinyjs::disable(selector = "[type=radio][value=open]")
    shinyjs::disable(selector = "[type=radio][value=spec]")
    shinyjs::runjs("$.each($('[type=radio][name=filetype]:disabled'), function(_, e){ $(e).parent().parent().css('opacity', 0.4) })")
  }
  else if (input$DDA_DIA == "DIA") {
    shinyjs::runjs("$('[type=radio][name=filetype]:disabled').parent().parent().parent().find('div.radio').css('opacity', 1)")
    shinyjs::enable("filetype")
    shinyjs::disable(selector = "[type=radio][value=maxq]")
    shinyjs::disable(selector = "[type=radio][value=prog]")
    shinyjs::disable(selector = "[type=radio][value=PD]")
    shinyjs::runjs("$.each($('[type=radio][name=filetype]:disabled'), function(_, e){ $(e).parent().parent().css('opacity', 0.4) })")
  }
  else if (input$DDA_DIA == "SRM_PRM") {
    shinyjs::runjs("$('[type=radio][name=filetype]:disabled').parent().parent().parent().find('div.radio').css('opacity', 1)")
    shinyjs::enable("filetype")
    shinyjs::disable(selector = "[type=radio][value=open]")
    shinyjs::disable(selector = "[type=radio][value=spec]")
    shinyjs::disable(selector = "[type=radio][value=maxq]")
    shinyjs::disable(selector = "[type=radio][value=prog]")
    shinyjs::disable(selector = "[type=radio][value=PD]")
    shinyjs::runjs("$.each($('[type=radio][name=filetype]:disabled'), function(_, e){ $(e).parent().parent().css('opacity', 0.4) })")
    
  }
  
})
  
### functions ###

get_annot = reactive({
  annot <- input$annot
  if(is.null(annot)) {
    return(NULL)
  }
  read.csv(annot$datapath)
})

get_evidence = reactive({
  evidence <- input$evidence
  if(is.null(evidence)) {
    return(NULL)
    }
  read.csv(evidence$datapath)
})

get_data = reactive({
  if(is.null(input$filetype)) {
    return(NULL)
    }
  if(input$filetype == 'sample') {
    mydata <- read.csv("dataset.csv", header = T, sep = ";")
    }
  else {
    infile <- input$data
    if(is.null(infile)) {
      return(NULL)
    }
    if(input$filetype == '10col') {
      mydata <- read.csv(infile$datapath, header = T, sep = input$sep)
    }
    else if(input$filetype == 'sky') {
      mydata <- SkylinetoMSstatsFormat(data, annotation = get_annot())
    }
    else if(input$filetype == 'maxq') {
      mydata <- MaxQtoMSstatsFormat(data, annotation = get_annot(), evidence = get_evidence())
    }
    else if(input$filetype == 'prog') {
      mydata <- ProgenesistoMSstatsFormat(data, annotation = get_annot())
    }
    else if(input$filetype == 'PD') {
      mydata <- PDtoMSstatsFormat(data, annotation = get_annot())
    }
    else if(input$filetype == 'spec') {
      mydata <- SpectronauttoMSstatsFormat(data)
    }
    else if(input$filetype == 'open') {
      raw <- sample_annotation(data=data,
                               sample.annotation=get_annot(),
                               data.type='OpenSWATH')
      data.filtered <- filter_mscore(raw, 0.01)
      data.transition <- disaggregate(data.filtered)
      mydata <- convert4MSstats(data.transition)
    }}
  mydata <- unique(data.frame(mydata))
  return(mydata)
})

### outputs ###

output$template <- downloadHandler(
  filename <- function() {
    paste("templateannotation", "csv", sep=".")
  },
  
  content <- function(file) {
    file.copy("templateannotation.csv", file)
  },
  contentType = "csv"
)

output$template1 <- downloadHandler(
  filename <- function() {
    paste("templateevidence", "txt", sep = ".")
  },
  
  content <- function(file) {
    file.copy("templateevidence.txt", file)
  },
  contentType = "txt"
)

output$summary <- renderPrint(
  {
    req(get_data())
    str(get_data())
  }
)

output$summary1 <-  renderPrint(
  {
    req(get_data())
    summary(get_data())
  }
)

