# Load the required libraries
library("shiny")
library("shinythemes")
library("shinyWidgets")
library("shinymaterial")
library("markdown")
library("shinyFiles")


options(shiny.maxRequestSize = 1024^3)

# Define the UI
ui <- fluidPage(
  tags$head(
    tags$script(
      HTML("
        document.title = 'Sweep Discovery Tool';
      ")
    )
  ),
  theme = shinytheme("darkly"),
  tags$head(
    tags$style(HTML(
      "
      body {
        font-family: Arial, sans-serif;
      }
      
      .navbar {
        background-color: #375A7F;
        color: #fff;
        font-size: 19px;
      }
      
      .navbar-brand {
        color: #fff;
        font-size: 24px;
        font-weight: bold;
      }
      
      .nav-link {
        color: #fff;
        font-size: 24px;
      }
      
      .jumbotron {
        background-color: #f8f9fa;
        padding: 40px;
        margin-bottom: 30px;
      }
      
      .jumbotron h2 {
        font-weight: bold;
        color: #333;
      }
      
      .jumbotron p {
        color: #555;
      }
      
      .panel-heading {
        background-color: #333;
        color: #fff;
        padding: 10px;
        border-radius: 4px;
      }
      
      .panel-body {
        padding: 20px;
      }
      
      .btn-primary {
        background-color: #007bff;
        border-color: #007bff;
      }
      
      .btn-primary:hover {
        background-color: #0069d9;
        border-color: #0062cc;
      }
      
      .custom-sidebar {
        width: 400px;
      }
      
      .custom-align {
        display: flex;
        align-items: center;
        justify-content: center;
      }
      
      .predict-panel {
        background-color: rgba(248, 249, 250, 0.25);
        padding: 20px;
        height: 350px;
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
      }
      
      .predict-description {
        color: #fff;
        text-align: center;
        margin-bottom: 30px;
        font-size: 28px;
      }
      
      .predict-button {
        display: flex;
        justify-content: center;
        margin-top: 30px;
      }
      "
    ))
  ),
  
  navbarPage(
    title = NULL,
    collapsible = TRUE,
    theme = "bootstrap",
    tabPanel("Home", includeHTML("aboutSweep.html")),
    
    tabPanel(
      "Predict",
      sidebarPanel(
        tags$label(h2("Input parameters", align = "center")),
        textInput("dir_name", "Enter Directory Name"),
        actionButton("save_button", "Save Files"),
        fileInput("file_upload","Choose Input Files",multiple=TRUE),
        textInput("Chromosome","Choose Chromosome No/Identifier",value=1),
        numericInput("start","Choose Start Position",value=1),
        numericInput("end","Choose End Position",value=1),
        actionButton("submitbutton", "Predict", class = "btn btn-primary btn-lg btn-block"),
        class = "custom-sidebar"
      ),
      mainPanel(
        div(
          class = "predict-panel",
          p(class = "predict-description", "Predicted Sweep Status will appear here"),
          tableOutput("ms"),
          div(class = "predict-button",
              downloadButton("downloadData", "Download Results", class = "btn btn-primary")
          )
        )
      ), includeMarkdown("predict.md")
    ),
    tabPanel(
      "Data Availability",
      titlePanel("Download Datasets"),
      div(
        tabsetPanel(
        tabPanel("Example Data", includeMarkdown("example_data.md"), br(), downloadButton("downloadButton1", "Download Zipped File")
          )
        ),
        align = "justify"
      )
    ),
    
    tabPanel("Developers", includeHTML("developersSweep.html")),
    tabPanel("Contact Details", includeHTML("contact-details.html"))
    
  )
)