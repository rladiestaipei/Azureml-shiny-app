#===========================================================================
# Library
setwd("C:/Users/v-ivwa/Desktop/Rscript/Bank/Azureml-shiny-app/Practice_Shiny/Bank_Marketing")
#===========================================================================
library(shiny)
#===========================================================================
# Data Prepare for selectInput,sliderInput,numericInput
#===========================================================================
#---- selectInput for classfication variable ----
marital <- c("married",
             "single",
             "divorced",
             "unknown")
housing <- c("no","unknown","yes")
loan<- c("no","unknown","yes")
poutcome<- c("success",
             "nonexistent",
             "failure")



#---- numericInput ----
age_max = 88
age_min = 18

campaign_max = 35
campaign_min = 1


#===========================================================================
# Shiny Layout
#===========================================================================
shinyUI(
  fluidPage( 
  
    titlePanel("Bank Test"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput( inputId = "marital",
                   label = "marital:", 
                   choices = marital),
      
      
      selectInput( inputId = "loan", 
                   label = "loan:", 
                   choices=loan),
      
      selectInput( inputId = "housing", 
                   label = "housing:", 
                   choices=housing),
      
      selectInput( inputId = "poutcome", 
                   label = "poutcome:", 
                   choices=poutcome),
      
      
      numericInput( inputId = "age", 
                    label = "AGE:", 
                    min = age_min, max = age_max, value =age_max, step = 1),
      
      numericInput( inputId = "campaign", 
                    label = "campaign:", 
                    min = campaign_min, max = campaign_max, value =campaign_max, step = 1)
      ),
 
    mainPanel( textOutput("result_text") )
           )
  
      )
  )
