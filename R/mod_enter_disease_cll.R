#' enter_disease_cll UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_enter_disease_cll_ui <- function(id){
  ns <- NS(id)
  tagList(
    selectInput(inputId = ns("clldist")
                ,label = "Disease status at time of HCT"
                ,choices = list("CR" = 1
                                ,"PR" = 2
                                ,"Stable/Progressive" = 3
                                ,"Unknown" = 99
                                )
                ,selected = 1
                )
    ,selectInput(inputId = ns("cll17pab")
                ,label = "17p abnormality"
                ,choices = list("No" = 0
                                ,"Yes" = 1
                                ,"Unknown" = 99
                )
                ,selected = 0
    )
  )
}

#' enter_disease_cll Server Functions
#'
#' @noRd
mod_enter_disease_cll_server <- function(id, upload_dxsub){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observe({
          updateSelectInput(session
                            , "clldist"
                            , selected = upload_dxsub$selected_df$clldist
          )
          updateSelectInput(session
                            , "cll17pab"
                            , selected = upload_dxsub$selected_df$cll17pab
          )
    })

    vals <- reactiveValues()
    observe({vals$df <- data.frame("clldist"   = input$clldist
                                   ,"cll17pab" = input$cll17pab
                                   )
    })
    return(vals)

  })
}

## To be copied in the UI
# mod_enter_disease_cll_ui("enter_disease_cll_1")

## To be copied in the server
# mod_enter_disease_cll_server("enter_disease_cll_1")
