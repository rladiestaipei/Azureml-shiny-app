#===========================================================================
# Library
#===========================================================================
library(shiny)
library(bitops)
library(RCurl)
library(rjson)

#===========================================================================
# Server
#===========================================================================
function(input, output) {
  #==== Get UI.R's input ====
  Ui_input <- reactive({ 
   return( list( 'PassengerClass' = input$PassengerClass,
                 'Gender' = input$Gender ,
                 'Age' = as.character(input$Age),
                 'SiblingSpouse' = as.character(input$SiblingSpouse) ,
                 'ParentChild' = as.character(input$ParentChild),
                 'FarePrice' = as.character(input$FarePrice),
                 'PortEmbarkation' = input$PortEmbarkation ) )
  })
  
  #==== Output : Prediction ====   
  output$result_plot <- renderImage({
    #---- Connect to Azure ML workspace ----  
    options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))
    # Accept SSL certificates issued by public Certificate Authorities
    
    h = basicTextGatherer()
    hdr = basicHeaderGatherer()
    
    #---- Put input_data to Azure ML workspace ----
    req = list(
      Inputs = list(
        "input1" = list(
          Ui_input()
        )
      ),
      GlobalParameters = setNames(fromJSON('{}'), character(0))
    )
    
    #---- Web service : API key ----
    body = enc2utf8(toJSON(req))
    api_key = " Your api Key " 
    authz_hdr = paste('Bearer', api_key, sep=' ')
    
    h$reset()
    curlPerform(url = "Your Request-Response URL ",
                httpheader=c('Content-Type' = "application/json", 'Authorization' = authz_hdr),
                postfields=body,
                writefunction = h$update,
                headerfunction = hdr$update,
                verbose = TRUE
    )
    
    #---- Get Result  ----
    result = fromJSON( h$value() )$Results$output2[[1]]$PredictedSurvived
    
    if ( result == "1") {
      return( list(
        src = "www/survived.png",
        height = 480, width = 700,
        alt = "Survived"
      ))
    }else if ( result == "0") {
      return(list(
        src = "www/deceased.png",
        height = 480, width = 700,
        alt = "Deceased"
      ))
    }
  }, deleteFile = FALSE)
}
