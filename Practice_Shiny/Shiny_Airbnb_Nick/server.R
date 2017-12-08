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
    return( list("ColumnNames" = list("room_type", "neighborhood", "accommodates", "bedrooms"),
            "Values" = list( list( input$room_type, as.character(input$neighborhood), as.character(input$accommodates), as.character(input$bedrooms) ))))
  })
  
  output$result_plot <- renderImage({
    
    if (input$room_type == "Shared room"){
      return( list(
        src = "www/shared_room.png",
        height = 400, width = 600,
        alt = "Shared room"
      ))}
    
    else if (input$room_type == "Entire home/apt"){
      return( list(
        src = "www/Entire_home_apt.jpg",
        height = 400, width = 600,
        alt = "Entire home/apt"
      ))}
    else if (input$room_type == "Private room"){
      return( list(
        src = "www/Private_room.jpg",
        height = 400, width = 600,
        alt = "Private room"
      ))}
    
  }, deleteFile = FALSE)

  
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
        "input1" = Ui_input()
      ),
      GlobalParameters = setNames(fromJSON('{}'), character(0))
    )
    
    #---- Web service : API key ----
    url = "your_url"
    api_key = "your_api_key"  ###### Check 2 ######
    
    
    body = enc2utf8(toJSON(req))
    authz_hdr = paste('Bearer', api_key, sep=' ')
    print(body)
    h$reset()
    curlPerform(url = url,
                httpheader=c('Content-Type' = "application/json", 'Authorization' = authz_hdr),
                postfields=body,
                writefunction = h$update,
                headerfunction = hdr$update,
                verbose = TRUE
    )
    
    #---- Get Result  ----
    result = h$value()
    print(result)
    result = fromJSON(result)$Results$output1$value$Values
    print(result)
    result = toString(round(as.double(result), digit = 2))
    return(sprintf("Predicted Price:  $%s", result))
  })
}