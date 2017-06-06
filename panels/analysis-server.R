

### functions ###

# quantification

abundance <- reactive({
  quantification(preprocess_data(),
                 type = input$typequant,
                 format = input$format)
})

# downloads

output$download_summary <- downloadHandler(
  filename = function() {
    paste("data-", Sys.Date(), ".csv", sep="")
  },
  content = function(file) {
    write.csv(abundance(), file)
  }
)

# annotation

ensembl <- useMart("ensembl")
dbs <- listDatasets(ensembl)


output$Species <- renderUI({
  selectizeInput("species", "", dbs[2], options = list(placeholder = "select"))
})

dataset.input <- reactive({
  as.character(dbs$dataset[dbs$description == input$species])
})

ensembl1 <- reactive(useDataset(dataset.input(), mart = ensembl))

filters <- reactive(listFilters(ensembl1()))

output$Filter <- renderUI ({
  selectizeInput("filter", "", filters()[2], options = list(placeholder = "select"))
})

filter.input <- reactive({
  as.character(filters()$name[filters()$description == input$filter])
})

attributes <- reactive({listAttributes(ensembl1())
})

output$Attributes <- renderUI ({
  selectizeInput("attribute_input", "", attributes(), multiple=TRUE, options = list(placeholder="select attributes"))
})

attribute.input <- reactive({
  as.vector(input$attribute_input)
})


id <- reactive(SignificantProteins()[1])
    
  

results <- reactive({
  getBM(attributes = attribute.input(),
                 filters = filter.input(), 
                 values = id(),
                 mart = ensembl1())
})

# table output

output$annotation <- renderTable({
#  merge(SignificantProteins()[,c(1,2,3,8)], results(), by.x="Protein", by.y="ensembl_gene_id")
results()
})

# download

output$table_annot <-downloadHandler(
  filename = function() {
    paste("annotation-", Sys.Date(), ".csv", sep="")
  },
  content = function(file) {
    write.csv(results(), file)
  }
)