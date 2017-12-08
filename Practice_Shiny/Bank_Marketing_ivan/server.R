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
  
  Ui_input <- reactive({ ###### Check 1 ######
    return( list( "age" = input$age,
                  "marital" = as.character(input$marital) ,
                  "housing" = as.character(input$housing) ,
                  "loan" = as.character(input$loan),
                  "campaign" = input$campaign,
                  'poutcome' = as.character(input$poutcome)
                  ) )
  })
  #print(Ui_input)
  #==== Output : Prediction ====   
  output$result_text <- renderText({
    #---- Connect to Azure ML workspace ----  
    options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))
    # Accept SSL certificates issued by public Certificate Authorities
    
    h = basicTextGatherer()
    hdr = basicHeaderGatherer()
    
    #---- Put input_data to Azure ML workspace ----
    req =  list(
      Inputs = list(
        "input1"= list(
          Ui_input()
        )
      ),
      GlobalParameters = setNames(fromJSON('{}'), character(0))
    )
    
    #---- Web service : API key ----
    
    body = enc2utf8(toJSON(req))
    api_key = "brIDPvSo17Qowr96ZsRPGh3AK4gE1q045TQDoM6+BR+slImPtD2wKUvxcTP6pNsHDkSqKVDyL2Kbjl2RU9Ph4A==" # Replace this with the API key for the web service
    authz_hdr = paste('Bearer', api_key, sep=' ')
    
    h$reset()
    curlPerform(url = "https://ussouthcentral.services.azureml.net/workspaces/ae5e6b1aa49847228498327c4960d383/services/821ada129ca449078180ed909082f219/execute?api-version=2.0&format=swagger",
                httpheader=c('Content-Type' = "application/json", 'Authorization' = authz_hdr),
                postfields=body,
                writefunction = h$update,
                headerfunction = hdr$update,
                verbose = TRUE
    )
    
    #---- Get Result  ----
    
    result = fromJSON( h$value() )$Results$output1[[1]]$Predicted
    
  
  })
}
