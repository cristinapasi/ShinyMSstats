### functions ###

get_annot = reactive({
  annot <- input$annot
  if(is.null(annot))
    return(NULL)
  read.csv(annot$datapath)
})

get_evidence = reactive({
  evidence <- input$evidence
  if(is.null(evidence))
    return(NULL)
  read.csv(evidence$datapath)
})



get_data = reactive({
  if(input$filetype == 'sample') {
    mydata <- read.csv("dataset.csv", header = T, sep = ";")
  }
  
  else {
  
  infile <- input$data
  if(is.null(infile))
    {return(NULL)}
  
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
#  session$userData$dataset = 
  return(mydata)
})




### outputs ###


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

