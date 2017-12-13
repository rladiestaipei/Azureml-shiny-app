library("RCurl")
library("rjson")


if(nrow(dataset)>0)
{
  createList <- function(dataset)     ###### Check 1 ######
  {
    temp <- list( 'Pclass' = as.character(dataset[1,1]),
                  'Sex' = as.character(dataset[1,2]),
                  'Age' =as.character(dataset[1,3]) )
    return(temp)
  }
  
  #---- Connect to Azure ML workspace ----  
  options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))
  # Accept SSL certificates issued by public Certificate Authorities
  
  h = basicTextGatherer()
  hdr = basicHeaderGatherer()
  
  #---- Put input_data to Azure ML workspace ----
  req = list(
    Inputs = list(
      "input1" = list(
        createList(dataset)
      ) 
    ),
    GlobalParameters = setNames(fromJSON('{}'), character(0))
  )
  
  #---- Web service : API key ----
  body = enc2utf8(toJSON(req))
  api_key = "Your API"   ###### Check 2 ######
  authz_hdr = paste('Bearer', api_key, sep=' ')
  
  h$reset()
  curlPerform(url = "Your Request-Response URL",  ###### Check 3 ######
              httpheader=c('Content-Type' = "application/json", 'Authorization' = authz_hdr),
              postfields=body,
              writefunction = h$update,
              headerfunction = hdr$update,
              verbose = TRUE
  )
  
  #---- Get Result  ----
  result = fromJSON(h$value())$Results$output1[[1]]$Predicted
  
}else{ result="No Data" }

library(gridExtra)

mytheme <- gridExtra::ttheme_default(
  core = list(fg_params=list(cex = 5.0)))

grid.table(result, theme = mytheme)