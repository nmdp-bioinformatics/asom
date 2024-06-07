#' enter_disease_cml UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_enter_disease_cml_ui <- function(id){
  ns <- NS(id)
  tagList(
    selectInput(inputId = ns("cmldist")
                ,label = "Disease status at time of HCT"
                ,choices = c("Hematologic CR" = 1
                             ,"Chronic phase" = 2
                             ,"Accelerated phase/Blast phase" = 3
                             ,"Unknown" = 99
                             )
                ,selected = 2
    )

  )
}

#' enter_disease_cml Server Functions
#'
#' @noRd
mod_enter_disease_cml_server <- function(id, upload_dxsub){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observe({
          updateSelectInput(session
                            , "cmldist"
                            , selected = upload_dxsub$selected_df$cmldist
          )
    })

    vals <- reactiveValues()
    observe({vals$df <- data.frame("cmldist" = input$cmldist)
    })
    return(vals)

  })
}

## To be copied in the UI
# mod_enter_disease_cml_ui("enter_disease_cml_1")

## To be copied in the server
# mod_enter_disease_cml_server("enter_disease_cml_1")
