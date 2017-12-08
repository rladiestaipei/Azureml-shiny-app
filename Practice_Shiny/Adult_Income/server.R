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
   return( 
     list('age' = as.character(input$age),
          'workclass' = input$workclass,
          'fnlwgt' = as.character(input$fnlwgt),
          'education' = input$education,
          'educationalnum' = as.character(input$educationalnum),
          'maritalstatus' = input$maritalstatus,
          'occupation' = input$occupation,
          'relationship' = input$relationship,
          'race' = input$race,
          'gender' = input$gender,
          'capitalgain' = as.character(input$capitalgain),
          'capitalloss' = as.character(input$capitalloss),
          'hoursperweek' = as.character(input$hoursperweek),
          'nativecountry' = input$nativecountry,
          'income' = input$income
    ) 
  )
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
    api_key = "ivb94L4lPcpRYfGLbvItlUs2I6odQYRVKIylaKwpZmc4mDogx7fAZX3y/FBFguIKvT2cR1XTQrlNh+72CWWyEw=="  ###### Check 2 ######
    authz_hdr = paste('Bearer', api_key, sep=' ')
    
    h$reset()
    curlPerform(url = "https://ussouthcentral.services.azureml.net/workspaces/93acda37273048f0a19f8d5d6a9cd574/services/d80d424f4c404f1596d4b4e2c14eb39c/execute?api-version=2.0&format=swagger",   ###### Check 3 ######
                httpheader=c('Content-Type' = "application/json", 'Authorization' = authz_hdr),
                postfields=body,
                writefunction = h$update,
                headerfunction = hdr$update,
                verbose = TRUE
    )
    
    #---- Get Result  ----
    result = fromJSON( h$value() )$Results$output1[[1]]$Predict  ###### Check 4 ######
    
    if ( result == "<=50K") {
      return( list(
        src = "www/under50.jpeg",
        height = 480, width = 700,
        alt = "收入小於50萬"
      ))
    }else if ( result == ">50K") {
      return(list(
        src = "www/over50.jpg",
        height = 480, width = 700,
        alt = "收入大於50萬"
      ))
    }
  }, deleteFile = FALSE)
}
