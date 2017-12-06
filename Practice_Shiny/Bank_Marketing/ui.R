#===========================================================================
# Library
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
default <- c("no","unknown","yes")
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
  
    titlePanel("銀行行銷預測系統"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput( inputId = "marital",
                   label = "婚姻狀況 : ", 
                   choices = marital),
      
      selectInput( inputId = "default", 
                   label = "是否違約信用紀錄 : ", 
                   choices=default),
      
      
      selectInput( inputId = "loan", 
                   label = "是否有貸款記錄 : ", 
                   choices=loan),
      
      selectInput( inputId = "housing", 
                   label = "是否有住房貸款 : ", 
                   choices=housing),
      
      selectInput( inputId = "poutcome", 
                   label = "過去推銷的活動是否成功 : ", 
                   choices=poutcome),
      
      
      numericInput( inputId = "age", 
                    label = "年齡 : ", 
                    min = age_min, max = age_max, value =age_max, step = 1),
      
      numericInput( inputId = "campaign", 
                    label = "聯繫過次數 : ", 
                    min = campaign_min, max = campaign_max, value =campaign_max, step = 1)
      ),
 
    mainPanel( textOutput("result_text") )
           )
  
      )
  )
