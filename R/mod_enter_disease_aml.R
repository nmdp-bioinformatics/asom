#' enter_disease_aml UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_enter_disease_aml_ui <- function(id){
  ns <- NS(id)
  tagList(
    selectInput(inputId = ns("aldist_aml")
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
    ,selectInput(inputId = ns("indcycle_aml")
                ,label = "AML: Number of induction cycles to achieve CR1"
                ,choices = c("1" = 1
                             ,"2" = 2
                             ,"3+" = 3
                             ,"Unknown" = 99
                             )
                ,selected = 1
                )
    ,selectInput(inputId = ns("cytogeneaml")
                 ,label = "Cytogenetic ELN risk group for AML"
                 ,choices = c("Normal" = 1
                              ,"Favorable" = 2
                              ,"Intermediate" = 3
                              ,"Poor" = 4
                              ,"APL" = 5
                              ,"Unknown" = 99
                              )
                 ,selected = 4
                 )
    ,selectInput(inputId = ns("mdstfaml")
                 ,label = "AML progression from MDS"
                 ,choices = c("No" = 0
                              ,"Yes" = 1
                              ,"Unknown" = 99
                              )
                 ,selected = 0
    )
    ,selectInput(inputId = ns("amlrxrel")
                 ,label = "Therapy related AML"
                 ,choices = c("No" = 0
                              ,"Yes" = 1
                              ,"Unknown" = 99
                 )
                 ,selected = 0
    )
  )
}

#' enter_disease_aml Server Functions
#'
#' @noRd
mod_enter_disease_aml_server <- function(id, upload_dxsub){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observe({
          updateSelectInput(session
                            , "aldist_aml"
                            , selected = upload_dxsub$selected_df$aldist_aml
          )
          updateSelectInput(session
                            , "indcycle_aml"
                            , selected = upload_dxsub$selected_df$indcycle_aml
          )
          updateSelectInput(session
                            , "cytogeneaml"
                            , selected = upload_dxsub$selected_df$cytogeneaml
          )
          updateSelectInput(session
                            , "mdstfaml"
                            , selected = upload_dxsub$selected_df$mdstfaml
          )
          updateSelectInput(session
                            , "amlrxrel"
                            , selected = upload_dxsub$selected_df$amlrxrel
          )
    })

    vals <- reactiveValues()
    observe({vals$df <- data.frame("aldist_aml"    = input$aldist_aml
                                   ,"indcycle_aml" = input$indcycle_aml
                                   ,"cytogeneaml"  = input$cytogeneaml
                                   ,"mdstfaml"     = input$mdstfaml
                                   ,"amlrxrel"     = input$amlrxrel
                                   )
    })
    return(vals)

  })
}

## To be copied in the UI
# mod_enter_disease_aml_ui("enter_disease_aml_1")

## To be copied in the server
# mod_enter_disease_aml_server("enter_disease_aml_1")
