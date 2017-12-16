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
  UI_input <- reactive({  list( 'Pclass' = input$PassengerClass,
                                'Sex' = input$Gender ,
                                'Age' = as.character(input$Age)
                              )
                       })
  
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
          UI_input()
        )
      ),
      GlobalParameters = setNames(fromJSON('{}'), character(0))
    )
    
    
    #---- Web service : API key ----
    body = enc2utf8(toJSON(req))
    api_key = "Your API" 
    authz_hdr = paste('Bearer', api_key, sep=' ')
    
    h$reset()
    curlPerform(url = "https://ussouthcentral.services.azureml.net/workspaces/601fb81f029145e7a98b85fe3cfd57e5/services/8f12ba4343ce457da26a3e72e3d1ed21/execute?api-version=2.0&format=swagger",
                httpheader=c('Content-Type' = "application/json", 'Authorization' = authz_hdr),
                postfields=body,
                writefunction = h$update,
                headerfunction = hdr$update,
                verbose = TRUE
    )
    
    #---- Get Result  ----
    result = h$value()
    
    if (fromJSON(result)$Results$output1[[1]]$`Scored Labels` == "1") {
      return( "存活")
    }else if (fromJSON(result)$Results$output1[[1]]$`Scored Labels` == "0") {
      return("死亡")
      }
    } )
}

