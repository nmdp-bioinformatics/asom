#' enter_disease_hd UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_enter_disease_hd_ui <- function(id){
  ns <- NS(id)
  tagList(
    selectInput(inputId = ns("lymresist_hd")
                ,label = "Disease status prior to HCT"
                ,choices = list("Not chemoresistant" = 0
                                ,"Chemoresistant" = 1
                                ,"Unknown" = 99
                )
                ,selected = 0
    )

  )
}

#' enter_disease_hd Server Functions
#'
#' @noRd
mod_enter_disease_hd_server <- function(id, upload_dxsub){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observe({
          updateSelectInput(session
                            , "lymresist_hd"
                            , selected = upload_dxsub$selected_df$lymresist_hd
          )
    })

    vals <- reactiveValues()
    observe({vals$df <- data.frame("lymresist_hd" = input$lymresist_hd)
    })
    return(vals)

  })
}

## To be copied in the UI
# mod_enter_disease_hd_ui("enter_disease_hd_1")

## To be copied in the server
# mod_enter_disease_hd_server("enter_disease_hd_1")
