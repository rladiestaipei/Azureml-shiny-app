#===========================================================================
# Library
#===========================================================================
library(shiny)
library(dplyr)
library(data.table)
library(bitops)
library(RCurl)
library(rjson)

#===========================================================================
# Server
#===========================================================================
function(input, output) {
  #==== Get UI.R's input ====
  Ui_input <- reactive({   ###### Check 2 ######
    return( list(
                 'price' = input$price,
                 'vehicleType' = input$vehicleType,
                 'gearbox' = input$gearbox,
                 'powerPS' = input$powerPS,
                 'notRepairedDamage' = input$ifRepair ) )
  })
  
  #==== Output : Prediction ====
  
  output$result_plot <- renderImage({
    
    if (input$vehicleType == "bus"){
      return( list(
        src = "www/schoolbus.jpg",
        height = 400, width = 600,
        alt = "bus"
      ))}
    
    else if (input$vehicleType == "cabrio"){
      return( list(
        src = "www/cabrio.jpg",
        height = 400, width = 600,
        alt = "cabrio"
      ))}
    else if (input$vehicleType == "kombi"){
      return( list(
        src = "www/kombi.jpg",
        height = 400, width = 600,
        alt = "kombi"
      ))}
    else if (input$vehicleType == "kleinwagen"){
      return( list(
        src = "www/kleinwagen.jpg",
        height = 400, width = 600,
        alt = "kleinwagen"
      ))}
    else if (input$vehicleType == "suv"){
      return( list(
        src = "www/suv.jpg",
        height = 400, width = 600,
        alt = "suv"
      ))}
    else if (input$vehicleType == "coupe"){
      return( list(
        src = "www/coupe.jpg",
        height = 400, width = 600,
        alt = "coupe"
      ))}
    else if (input$vehicleType == "limousine"){
      return( list(
        src = "www/limousine.jpg",
        height = 400, width = 600,
        alt = "limousine"
      ))}
    
  }, deleteFile = FALSE)
  
  output$result_text <- renderText({
    
    #---- Connect to Azure ML workspace ----  
    ""
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
    api_key = "W/YmduFYAfGV6iwXePJSY0F2+7/xdbhZB9K/clVUctPuJGal6g8w3w80O6hoV+vq8x9ViyBs+mlQpPU+qM/zrg=="   ###### Check 3 ######
    authz_hdr = paste('Bearer', api_key, sep=' ')
    
    h$reset()
    curlPerform(url = "https://ussouthcentral.services.azureml.net/workspaces/a630219d0e1a4d058d5a9fed902cc2c7/services/8be6d4dacb904582bf7d42349f43e4ef/execute?api-version=2.0&format=swagger",   ###### Check 4 ######
                httpheader=c('Content-Type' = "application/json", 'Authorization' = authz_hdr),
                postfields=body,
                writefunction = h$update,
                headerfunction = hdr$update,
                verbose = TRUE
    )

    result = h$value()
    print(fromJSON(result)$Results$output1[[1]]$PredictedPrice)
    result = h$value()
    result = fromJSON(result)$Results$output1[[1]]$PredictedPrice
    #result = toString(round(as.double(result), digit = 2))
    return(sprintf("Predicted Price:  $%s", result))
    #---- Get Result  ----
    #result1 = fromJSON( h$value() )$Results$output1[[1]] #<- Add Parse Result Here   ###### Check 5 ######
     }, )
   }
 
