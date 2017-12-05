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
  Ui_input <- reactive({   ###### Check 1 ######
    return( list('vehicleType' = input$vehicleType,
                 'gearbox' = input$gearbox,
                 'powerPS' = input$powerPS,
                 'notRepairedDamage' = input$ifRepair ) )
  })
  
  #==== Output : Prediction ====   
  output$result_text <- renderText({
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
    api_key = "YourAPI"   ###### Check 2 ######
    authz_hdr = paste('Bearer', api_key, sep=' ')
    
    h$reset()
    curlPerform(url = "YourURL",   ###### Check 3 ######
                httpheader=c('Content-Type' = "application/json", 'Authorization' = authz_hdr),
                postfields=body,
                writefunction = h$update,
                headerfunction = hdr$update,
                verbose = TRUE
    )
    
    #---- Get Result  ----
    result = fromJSON( h$value() )$Results$output1[[1]]$Predicted  #<- Add Parse Result Here   ###### Check 4 ######
     })
   }
 
