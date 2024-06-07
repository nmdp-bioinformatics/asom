#' enter_disease_nhl UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_enter_disease_nhl_ui <- function(id){
  ns <- NS(id)
  tagList(
    selectInput(inputId = ns("lymresist_nhl")
                ,label = "Disease status prior to HCT"
                ,choices = list("Not chemoresistant" = 0
                                ,"Chemoresistant" = 1
                                ,"Unknown" = 99
                )
                ,selected = 0
    )
    ,selectInput(inputId = ns("lymsubgp")
                 ,label = "Major disease subtype"
                 ,choices = list("Follicular" = 1
                                 ,"DLBCL" = 2
                                 ,"MCL" = 3
                                 ,"Other B-cell" = 4
                                 ,"T-cell" = 5
                                 ,"Unknown" = 99
                 )
                 ,selected = 5
    )
  )
}

#' enter_disease_nhl Server Functions
#'
#' @noRd
mod_enter_disease_nhl_server <- function(id, upload_dxsub){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observe({
          updateSelectInput(session
                            , "lymresist_nhl"
                            , selected = upload_dxsub$selected_df$lymresist_nhl
          )
          updateSelectInput(session
                            , "lymsubgp"
                            , selected = upload_dxsub$selected_df$lymsubgp
          )
    })

    vals <- reactiveValues()
    observe({vals$df <- data.frame("lymresist_nhl" = input$lymresist_nhl
                                   ,"lymsubgp"     = input$lymsubgp
                                   )
    })
    return(vals)

  })
}

## To be copied in the UI
# mod_enter_disease_nhl_ui("enter_disease_nhl_1")

## To be copied in the server
# mod_enter_disease_nhl_server("enter_disease_nhl_1")
