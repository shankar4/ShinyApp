library(shiny)
shinyUI(fluidPage(
  titlePanel("KNN Clustering with PCA Preprocessing"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("KNN clustering of motorcar data with PCA"),
      helpText("The mpg data is discretized to study the effect of discretization on clustering accuracy"),
      helpText("PCA tolerance is also varied to study its interaction with discretization on clustering accuracy "),
      selectInput("level", 
                  label = "Choose number of mpg discretization levels:",
                  choices = c("5", "10",
                              "15", "20"),
                  selected = "10"),
      
      sliderInput("tol", 
                  label = "Choose PCA Tolerance:",
                  min = 0, max = 1.0, value = 0.05)
      ),
    
    mainPanel(
      helpText("You chose the following discretization level"),
      textOutput("text1"),
      helpText("You chose the following PCA tolerance level"),
      textOutput("text2"),
      helpText("The resulting KNN clustering accuracy is as follows"),
      textOutput("Accuracy"),
      helpText("Note: Try a discretization level of 15. Accuracy changes 10 to 50% with change in PCA tolerance")
    )
  )
))