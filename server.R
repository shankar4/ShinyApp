library(shiny)
library(datasets)
#This is working - even if partially!
shinyServer(function(input, output) {
  
  output$text1 <- renderText({ 
      paste("Discrete Levels chosen:", input$level)
    })
  output$text2 <- renderText({ 
      paste("PCA tolerance chosen:",
             input$tol)
    })
  
  tol.new <- reactive({
    input$tol
  })
  level.new <- reactive({
    input$level
  })
  # as.numeric(level.new()), new.acc()
  #new.acc <- reactive({add <- function (a,b){a+b}})
  data(mtcars)
  cars <- mtcars
  library(MASS)
  library(class)
  discrete <- function(a){
    #data(mtcars)
    #cars <- mtcars
    cut(cars$mpg, as.numeric(a)) # - only this line is needed
    
    #InTrain <- unlist( training.rows )
    #levels
    #cars$mpg <- levels
    #a + 10
  }
  
  levels <- reactive({ discrete(level.new()) }) 
  #new.acc <- reactive ({ add (accuracy, as.numeric(level.new())) })
  #cars$mpg <- levels()
  #cluster <- 
  cluster <- function (b,c){  # c is tol , b is levels
    cars$mpg <- b
    set.seed(32343)
    training.rows <- tapply(1:nrow(cars), cars$mpg , sample , size =4, replace=TRUE)
    InTrain <- unlist( training.rows )
    train.set <- cars[InTrain,]
    valid.set <- cars[-InTrain,]
    library(MASS)
    preProc <- prcomp(train.set[,-1], scale=TRUE, center=TRUE, tol = c)
    trainPC <- predict(preProc,train.set[,-1])
    validPC <- predict(preProc,valid.set[,-1])
    library(class)
    #pred <- knn(train.set[,-1], valid.set[,-1], cl= train.set$mpg, k = 4,  prob = FALSE, use.all = TRUE)
    #obs <- valid.set$mpg
    #print obs
    trainPC.df <- as.data.frame(trainPC)
    validPC.df <- as.data.frame(validPC)
    pred <- knn(trainPC.df, validPC.df, cl= train.set$mpg, k = 4,  prob = FALSE, use.all = TRUE)
    obs <- valid.set$mpg
    count <- sum(pred==obs)
    round(100 * count/length(pred))
  }
  
  accuracy <- reactive({ cluster(levels(), tol.new()) }) 
  #accuracy <- reactive({tol.new() + 1})  - this works
  
  output$Accuracy <- renderText ({
    paste("Percentage Accuracy of Knn clustering:", accuracy())
  })
  
  })
  