library("randomForest")
library("PopGenome")
##Supress Warnings
options(warn=-1)
##Define Function
my_packages <- c("PopGenome","randomForest")

lapply(my_packages, require, character.only = TRUE) 

Sweep<- readRDS("models/SweepModel.rda")
# Define server function for the Shiny app
server <- function(input, output, session) {
  output$downloadButton1 <- downloadHandler(
    filename = function() {
      "example.zip"  # File name for the downloaded .zip file
    },
    content = function(file_example) {
      # Load the content of the .zip file
      zipContent <- readBin("data/Example_Data.zip", "raw", file.info("data/Example_Data.zip")$size)
      
      # Provide the .zip file for download
      file.copy("data/Example_Data.zip", file_example)
     
    }
  )

  #observe({
    #print(input$folder)}
#)
  # Shiny app logic
  observeEvent(input$save_button, {
    req(input$dir_name, input$file_upload)
    
    new_dir_path <- paste0("./", input$dir_name)
    
    if (!dir.exists(new_dir_path)) {
      dir.create(new_dir_path)
    }
    
    for (i in seq_along(input$file_upload$name)) {
      file.copy(input$file_upload$datapath[i], file.path(new_dir_path, input$file_upload$name[i]))
    }
    
  datasetInput <- reactive({
   
    data<-file.path(new_dir_path, input$file_upload$name[1])
    
    chromosome<-input$Chromosome
    start<- input$start
    finish<-input$end
    predict_res <-Sweep(Datapath=data,Chromosome = chromosome,Start = start,Finish = finish )
    res <- list(Pred = as.matrix(predict_res))
    })
  
  output$ms <- renderTable({
    if (input$submitbutton > 0) {
      predict_res<- datasetInput()
      ms <- predict_res
    }
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("SelectiveSweepStatus", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      res <- datasetInput()
      write.csv(res$Pred, file)
    }
  )
  # Progress status
  observeEvent(input$submitbutton, {
    progress <- Progress$new(session, min = 0, max = 100)
    progress$set(message = 'Predicting...')
    
    # Run the prediction process in a separate reactive conductor
    predictionDone <- reactiveVal(FALSE)
    observeEvent(predictionDone(), {
      progress$close()
    })
    
    observe({
      if (!predictionDone()) {
        res <- datasetInput()
        ms <- res$Pred
        
        # Perform the prediction process here
        # Replace the code below with your actual prediction logic
        
        # Simulating the prediction process
        for (i in 1:100) {
          Sys.sleep(0.1)  # Simulating some processing time
          progress$set(value = i)
          if (i %% 10 == 0) {
            progress$set(message = paste0("Predicting...", i, "% complete"))
          }
        }
        
        # Set the predictionDone flag to indicate completion
        predictionDone(TRUE)
      }
    })
  })
}
)}
