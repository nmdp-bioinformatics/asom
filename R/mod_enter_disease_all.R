#' enter_disease_all UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_enter_disease_all_ui <- function(id){
  ns <- NS(id)
  tagList(
    selectInput(inputId = ns("aldist_all")
                ,label = "Disease status at time of HCT"
                ,choices = c("PIF" = 1
                             ,"CR1" = 2
                             ,"CR2" = 3
                             ,">=CR3" = 4
                             ,"Relapse" = 5
                             ,"Unknown" = 99
                )
                ,selected = 2
    )
    ,selectInput(inputId = ns("indcycle_all")
                ,label = "Number of induction cycles to achieve CR1"
                ,choices = c("1" = 1
                             ,"2" = 2
                             ,"3+" = 3
                             ,"Unknown" = 99
                             )
                ,selected = 1
    )
    ,selectInput(inputId = ns("philgp")
                 ,label = "Ph chromosome"
                 ,choices = c("No" = 0
                              ,"Yes" = 1
                              ,"Unknown" = 99
                              )
                 ,selected = 0
                 )
    ,selectInput(inputId = ns("allsubgp")
                 ,label = "ALL immunophenotype"
                 ,choices = c("T-cell" = 1
                              ,"B-cell" = 2
                              ,"Unknown" = 99
                              )
                 ,selected = 2
    )
    ,selectInput(inputId = ns("cytogeneall")
                 ,label = "Cytogenetic score"
                 ,choices = c("Normal" = 1
                              ,"Favorable" = 2
                              ,"Intermediate" = 3
                              ,"Poor" = 4
                              ,"Other" = 5
                              ,"Unknown" = 99
                              )
                 ,selected = 4
    )
    ,selectInput(inputId = ns("bcrrespr")
                 ,label = "BCR/ABL molecular marker at last evaluation"
                 ,choices = c("No" = 0
                              ,"Yes" = 1
                              ,"Unknown" = 99
                              )
                 ,selected = 0
    )
  )
}

#' enter_disease_all Server Functions
#'
#' @noRd
mod_enter_disease_all_server <- function(id, upload_dxsub){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observe({
          updateSelectInput(session
                            , "aldist_all"
                            , selected = upload_dxsub$selected_df$aldist_all
          )
          updateSelectInput(session
                            , "indcycle_all"
                            , selected = upload_dxsub$selected_df$indcycle_all
          )
          updateSelectInput(session
                            , "philgp"
                            , selected = upload_dxsub$selected_df$philgp
          )
          updateSelectInput(session
                            , "allsubgp"
                            , selected = upload_dxsub$selected_df$allsubgp
          )
          updateSelectInput(session
                            , "cytogeneall"
                            , selected = upload_dxsub$selected_df$cytogeneall
          )
          updateSelectInput(session
                            , "bcrrespr"
                            , selected = upload_dxsub$selected_df$bcrrespr
          )
    })

    vals <- reactiveValues()
    observe({vals$df <- data.frame("aldist_all"    = input$aldist_all
                                   ,"indcycle_all" = input$indcycle_all
                                   ,"philgp"       = input$philgp
                                   ,"allsubgp"     = input$allsubgp
                                   ,"cytogeneall"  = input$cytogeneall
                                   ,"bcrrespr"     = input$bcrrespr
                                   )
    })
    return(vals)

  })
}

## To be copied in the UI
# mod_enter_disease_all_ui("enter_disease_all_1")

## To be copied in the server
# mod_enter_disease_all_server("enter_disease_all_1")
