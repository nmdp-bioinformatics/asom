#' enter_demo UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_enter_demo_ui <- function(id){
  ns <- NS(id)
  tagList(
    numericInput(inputId = ns("age")
                       ,label = "Age"
                       ,min = 0
                       ,max = 100
                       ,value = 57
  )
  ,selectInput(inputId = ns("male")
               ,label = "Sex"
               ,choices = list("Male" = 1
                               ,"Female" = 0
                               ,"Uknown" = 99
               )
               ,selected = 1
  )
  ,selectInput(inputId = ns("racegp")
               ,label = "Race"
               ,choices = list("White" = 1
                               ,"Black or AA" = 2
                               ,"Asian" = 3
                               ,"NHOPI" = 4
                               ,"AIAN" = 5
                               ,"Other" = 7
                               ,"Multiple" = 8
                               ,"Unknown" = 99
               )
               ,selected = 1
  )
  ,selectInput(inputId = ns("ethnicit")
               ,label = "Ethnicity"
               ,choices = c("Hispanic or Latino" = 1
                            ,"Not Hispanic or Latino" = 2
                            ,"Unknown" = 99
               )
               ,selected = 2
  )
  ,numericInput(inputId = ns("coorgscore")
                ,label =  "HCT-CI"
                ,min = 0
                ,max = 20
                ,value = 2
                ,step = 1
                )
  ,numericInput(inputId = ns("karnofraw")
                ,label = "KPS"
                ,min = 10
                ,max = 100
                ,value = 90
                ,step = 10
                )
  ,textInput(inputId = ns("zipcode")
             ,label  = "5-digit zipcode (leave blank if unknown)"
             ,value = ""
             ,placeholder = "00000"
  )
  # ,numericInput(inputId = ns("median_income")
  #               ,label = "Median HH Income"
  #               ,min = 0
  #               ,max = 5000000
  #               ,value = 60000
  #               ,step = 1
  # )
  ,selectInput(inputId = ns("rcmvpos")
               ,label = "CMV+"
               ,choices = c("No" = 0
                            ,"Yes" = 1
                            ,"Uknown" = 99
               )
               ,selected = 1
  )
  ,selectInput(inputId = ns("venthxpr")
               ,label = "History of mechanical ventilation"
               ,choices = c("No" = 0
                            ,"Yes" = 1
                            ,"Uknown" = 99
               )
               ,selected = 0
  )
  ,selectInput(inputId = ns("funghxpr")
               ,label = "History of invasive fungal infection"
               ,choices = c("No" = 0
                            ,"Yes" = 1
                            ,"Uknown" = 99
               )
               ,selected = 0
  )
  ,selectInput(inputId = ns("priauto")
               ,label = "Prior autologous transplant"
               ,choices = list("No" = 0
                               ,"Yes" = 1
                               ,"Uknown" = 99
               )
               ,selected = 0
  )
  )
}

#' enter_demo Server Functions
#'
#' @noRd
mod_enter_demo_server <- function(id, upload){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observe({
          updateNumericInput(session
                             , "age"
                             , value = upload$selected_df$age
                             )
          updateSelectInput(session
                            , "male"
                            , selected = upload$selected_df$male
                            )
          updateSelectInput(session
                            , "racegp"
                            , selected = upload$selected_df$racegp
          )
          updateSelectInput(session
                            , "ethnicit"
                            , selected = upload$selected_df$ethnicit
          )
          updateNumericInput(session
                            , "coorgscore"
                            , value = upload$selected_df$coorgscore
          )
          updateNumericInput(session
                             , "karnofraw"
                             , value = upload$selected_df$karnofraw
          )
          updateSelectInput(session
                            , "zipcode"
                            , selected = upload$selected_df$zipcode
          )
          # updateSelectInput(session
          #                   , "median_income"
          #                   , selected = upload$selected_df$median_income
          # )
          updateSelectInput(session
                            , "rcmvpos"
                            , selected = upload$selected_df$rcmvpos
          )
          updateSelectInput(session
                            , "venthxpr"
                            , selected = upload$selected_df$venthxpr
          )
          updateSelectInput(session
                            , "funghxpr"
                            , selected = upload$selected_df$funghxpr
          )
          updateSelectInput(session
                            , "priauto"
                            , selected = upload$selected_df$priauto
          )
    }) |> bindEvent(upload$upload_count)

    vals <- reactiveValues()
    observe({vals$df <- data.frame("age" = input$age
                                  ,"male" = input$male
                                  ,"racegp" = input$racegp
                                  ,"ethnicit" = input$ethnicit
                                  ,"coorgscore" = input$coorgscore
                                  ,"karnofraw" = input$karnofraw
                                  ,"zipcode" = input$zipcode
                                  ,"median_income" = NA
                                  ,"rcmvpos" = input$rcmvpos
                                  ,"venthxpr" = input$venthxpr
                                  ,"funghxpr" = input$funghxpr
                                  ,"priauto" = input$priauto
                                  )
    })
    return(vals)

  })
}

## To be copied in the UI
# mod_enter_demo_ui("enter_demo_1")

## To be copied in the server
# mod_enter_demo_server("enter_demo_1")
