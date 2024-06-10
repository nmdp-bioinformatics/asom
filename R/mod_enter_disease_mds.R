#' enter_disease_mds UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_enter_disease_mds_ui <- function(id){
  ns <- NS(id)
  tagList(
    selectInput(inputId = ns("ipssrpr")
                 ,label = "IPSS-R at diagnosis"
                 ,choices = list("Very low" = 1
                                 ,"Low" = 2
                                 ,"Intermediate" = 3
                                 ,"High" = 4
                                 ,"Very high" = 5
                                 ,"Unknown" = 99
                 )
                 ,selected = 3
    )
    ,selectInput(inputId = ns("mdspredisp")
                ,label = "Predisposing condition"
                ,choices = list("No" = 0
                                ,"Yes" = 1
                                ,"Unknown" = 99
                )
                ,selected = 0
    )
    ,selectInput(inputId = ns("mdsrxrel")
                 ,label = "Therapy related MDS"
                 ,choices = list("No" = 0
                                 ,"Yes" = 1
                                 ,"Unknown" = 99
                 )
                 ,selected = 0
    )
  )
}

#' enter_disease_mds Server Functions
#'
#' @noRd
mod_enter_disease_mds_server <- function(id, upload_dxsub){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observe({
          updateSelectInput(session
                            , "ipssrpr"
                            , selected = upload_dxsub$selected_df$ipssrpr
          )
          updateSelectInput(session
                            , "mdspredisp"
                            , selected = upload_dxsub$selected_df$mdspredisp
          )
          updateSelectInput(session
                            , "mdsrxrel"
                            , selected = upload_dxsub$selected_df$mdsrxrel
          )
    })

    vals <- reactiveValues()
    observe({vals$df <- data.frame("ipssrpr"     = input$ipssrpr
                                   ,"mdspredisp" = input$mdspredisp
                                   ,"mdsrxrel"   = input$mdsrxrel
                                   )
    })
    return(vals)

  })
}

## To be copied in the UI
# mod_enter_disease_mds_ui("enter_disease_mds_1")

## To be copied in the server
# mod_enter_disease_mds_server("enter_disease_mds_1")
