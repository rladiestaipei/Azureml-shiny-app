#===========================================================================
# Library
#===========================================================================
library(shiny)
library(dplyr)
library(data.table)
library(RCurl)
library(rjson)

#===========================================================================
# Server
#===========================================================================
function(input, output) {
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
  
  #==== Output : Prediction ====   
  output$result_text <- renderText({
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
    api_key = "Your API" 
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
      return( "1")
    }else if (fromJSON(result)$Results$output2$value$Values == "0") {
      return("0")
      }
    }, )
}

