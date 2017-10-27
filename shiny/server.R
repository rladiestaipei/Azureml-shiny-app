#===========================================================================
# Library
#===========================================================================
library(shiny)
library(dplyr)
library(data.table)
library(RCurl)
library(rjson)
library(ggplot2)

#===========================================================================
# server.R
#===========================================================================
function(input, output) {
  #==== Setting path ====
  path = '~/Azure_ML_Titanic'
  
  #==== Get UI.R's input ====
  UI_input <- reactive({  v_1 <- input$PassengerClass
                          v_2 <- input$Gender 
                          v_3 <- as.character(input$Age)  
                          v_4 <- as.character(input$SiblingSpouse)  
                          v_5 <- as.character(input$ParentChild)  
                          v_6 <- as.character(input$FarePrice)  
                          v_7 <- input$PortEmbarkation
                          return(list( v_1,v_2,v_3,v_4,v_5,v_6,v_7 ))
                       })
  
  #==== Load Data for Training Data : Exploratory Data Analysis ====
  train <- fread(file.path(path, "Azure_ML_train.csv"))
  train$Survived=as.character(train$Survived)
  train$Survived[train$Survived=="1"]<-"Survived"
  train$Survived[train$Survived=="0"]<-"Deceased"
  
  #==== Output : Prediction ====   
  output$result_plot <- renderImage({
    #---- Connect to Azure ML workspace ----  
    options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))
    # Accept SSL certificates issued by public Certificate Authorities
    
    h = basicTextGatherer()
    hdr = basicHeaderGatherer()
    
    #---- UI input data ----    
    input_data = UI_input()
    
    #---- Put input_data to Azure ML workspace ----
    req = list(
      Inputs = list(
        "input1" = list(
          "ColumnNames" = list("PassengerClass", "Gender", "Age", "SiblingSpouse", "ParentChild", "FarePrice", "PortEmbarkation"),
          "Values" = list(  input_data  ) 
          #Example: input_data = list("3", "male", "50", "0", "0", "0", "A")
          )
        ),
      GlobalParameters = setNames(fromJSON('{}'), character(0))
      )
    
    #---- Web service : API key ----
    body = enc2utf8(toJSON(req))
    api_key = "Your api key" 
    authz_hdr = paste('Bearer', api_key, sep=' ')
    
    h$reset()
    curlPerform(url = "https://ussouthcentral.services.azureml.net/workspaces/852a506a05ab41868939caa8f97d3a57/services/c052c781636540b4a2530c5b753cb947/execute?api-version=2.0&details=true",
                httpheader=c('Content-Type' = "application/json", 'Authorization' = authz_hdr),
                postfields=body,
                writefunction = h$update,
                headerfunction = hdr$update,
                verbose = TRUE
    )
    
    #---- Get Result  ----
    result = h$value()
    
    if (fromJSON(result)$Results$output2$value$Values == "1") {
      return( list(
        src = "www/survived.png",
        height = 480, width = 700,
        alt = "Survived"
      ))
    }else if (fromJSON(result)$Results$output2$value$Values == "0") {
      return(list(
        src = "www/deceased.png",
        height = 480, width = 700,
        alt = "Deceased"
      ))
      }
    }, deleteFile = FALSE)

#==== Output : Training Data -- Exploratory Data Analysis ====   
  output$plot <- renderPlot({
    if( input$Variable == 'PassengerClass') {
      ggplot(train,aes(x=PassengerClass, fill=Survived)) + 
        geom_bar() + 
        scale_fill_brewer(palette = "Set1") + 
        ylab('') +
        ggtitle("PassengerClass vs Survived")
    }else if ( input$Variable == 'Gender') {
      ggplot(train,aes(x=Gender, fill=Survived)) + 
        geom_bar() + 
        scale_fill_brewer(palette = "Set1") + 
        ylab('') +
        ggtitle("Gender vs Survived")
    }else if ( input$Variable == 'Age') {
      ggplot(train[!is.na(train$Age),], aes(Age, fill = factor(Survived))) + 
        geom_histogram(bins=30) + 
        xlab("Age") +
        scale_fill_brewer(palette = "Set1",name = "Survived")+
        ggtitle("Age vs Survived")
    }else if ( input$Variable == 'SiblingSpouse' ) {
      ggplot(train,aes(x=SiblingSpouse, fill=Survived)) + 
        geom_bar() + 
        scale_fill_brewer(palette = "Set1") + 
        ylab('') +
        ggtitle("SiblingSpouse vs Survived")
    }else if ( input$Variable == 'ParentChild' ) {
      ggplot(train,aes(x=ParentChild, fill=Survived)) + 
        geom_bar() + 
        scale_fill_brewer(palette = "Set1") + 
        ylab('') +
        ggtitle("ParentChild vs Survived")
    }else if ( input$Variable == 'FarePrice') {
      ggplot(train[!is.na(train$FarePrice),], aes(FarePrice, fill = factor(Survived))) + 
        geom_histogram(bins=30) + 
        xlab("FarePrice") +
        scale_fill_brewer(palette = "Set1",name = "Survived")+
        ggtitle("FarePrice vs Survived")
    }else if ( input$Variable == 'PortEmbarkation' ) {
      ggplot(train,aes(x=PortEmbarkation, fill=Survived)) + 
        geom_bar() + 
        scale_fill_brewer(palette = "Set1") + 
        ylab('') +
        ggtitle("PortEmbarkation vs Survived")
      }
  })
}

