#' enter_disease_mm UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_enter_disease_mm_ui <- function(id){
  ns <- NS(id)
  tagList(
    selectInput(inputId = ns("mmissdsdx")
                ,label = "ISS stage at diagnosis"
                ,choices = list("Stage I-II" = 1
                                ,"Stage III" = 2
                                ,"Unknown" = 99
                )
                ,selected = 2
    )
    ,selectInput(inputId = ns("mmcytorisk")
                 ,label = "Cytogenic risk"
                 ,choices = list("Normal" = 0
                                 ,"High risk" = 1
                                 ,"Standard risk" = 3
                                 ,"Test not done/unknown/No metaphases" = 7
                                 ,"Unknown" = 99
                                 )
                 ,selected = 1
    )
    ,selectInput(inputId = ns("mmdist")
                 ,label = "Disease status prior to HCT"
                 ,choices = list("SCR/CR" = 1
                                 ,"VGPR" = 2
                                 ,"PR" = 3
                                 ,"SD" = 4
                                 ,"PD/Relapse" = 5
                                 ,"Unknown" = 99
                                 )
                 ,selected = 2
    )
  )
}

#' enter_disease_mm Server Functions
#'
#' @noRd
mod_enter_disease_mm_server <- function(id, upload_dxsub){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observe({
          updateSelectInput(session
                            , "mmissdsdx"
                            , selected = upload_dxsub$selected_df$mmissdsdx
          )
          updateSelectInput(session
                            , "mmcytorisk"
                            , selected = upload_dxsub$selected_df$mmcytorisk
          )
          updateSelectInput(session
                            , "mmdist"
                            , selected = upload_dxsub$selected_df$mmdist
          )
    })

    vals <- reactiveValues()
    observe({vals$df <- data.frame("mmissdsdx"   = input$mmissdsdx
                                   ,"mmcytorisk" = input$mmcytorisk
                                   ,"mmdist"     = input$mmdist
                                   )
    })
    return(vals)

  })
}

## To be copied in the UI
# mod_enter_disease_mm_ui("enter_disease_mm_1")

## To be copied in the server
# mod_enter_disease_mm_server("enter_disease_mm_1")
