#' enter_transplant UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_enter_transplant_ui <- function(id){
  ns <- NS(id)
  tagList(
    #  selectInput(inputId = ns("yeartx")
    #              ,label = "Year of transplant"
    #              ,choices = list("2024" = 2024)
    #              ,selected = patdat_default$yeartx
    # )
    selectInput(inputId = ns("condclas")
                 ,label = "Planned conditioning intensity"
                 ,choices = list("MAC" = 1
                                 ,"NMA" = 2
                                 ,"RIC" = 3
                                 ,"Unknown" = 99
                                 )
                 ,selected = patdat_default$condclas
                 )
    ,selectInput(inputId = ns("tbigp")
                 ,label = "TBI dose groups"
                 ,choices = list("No" = 0
                                ,"Yes" = 1
                                ,"Unknown" = 99
                                )
                 ,selected = patdat_default$tbigp
                 )

    ,selectInput(inputId = ns("graftgp")
                ,label = "Graft type"
                ,choices = list("Bone marrow" = 1
                                ,"Peripheral blood" = 2
                                ,"Unknown" = 99
                )
                ,selected = patdat_default$graftgp
    )
    ,selectInput(inputId = ns("gvhprhrx")
                  ,label =  "GVHD prophylaxis"
                  ,choices = list("TDEPLETION +- other" = 2
                                  ,"CD34 select +- other" = 4
                                  ,"Cyclophosphamide +- others" = 6
                                  ,"FK506 + MMF +- others" = 7
                                  ,"FK506 + MTX +- others(not MMF)" = 8
                                  ,"FK506 alone" = 10
                                  ,"CSA + MMF +- others(not FK506)" = 11
                                  ,"CSA + MTX +- others(not MMF,FK506)" = 12
                                  ,"CSA alone" = 14
                                  ,"Other GVHD Prophylaxis" = 20
                                  ,"Gvhproph=1, but no Proph agent"= 60
                                  ,"Unknown" = 99
                                  )
                  ,selected = patdat_default$gvhprhrx
    )
    # ,numericInput(inputId = ns("indxtx")
    #               ,label =  "Days from diagnosis to transplant"
    #               ,min = 0
    #               ,max = 100000
    #               ,value = patdat_default$indxtx
    #               ,step = 1
    # )
    ,selectInput(inputId = ns("invivotcd")
                ,label = "ATG/Campath use"
                ,choices = list("No" = 0
                                ,"Yes" = 1
                                ,"Unknown" = 99
                                )
                ,selected = patdat_default$invivotcd
    )


  )
}

#' enter_transplant Server Functions
#'
#' @noRd
mod_enter_transplant_server <- function(id, upload){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observe({
          # updateNumericInput(session
          #                    , "yeartx"
          #                    , value = upload$selected_df$yeartx
          # )
          updateSelectInput(session
                            , "condclas"
                            , selected = upload$selected_df$condclas
          )
          updateSelectInput(session
                            , "tbigp"
                            , selected = upload$selected_df$tbigp
          )
          updateSelectInput(session
                            , "graftgp"
                            , selected = upload$selected_df$graftgp
          )
          updateSelectInput(session
                            , "gvhprhrx"
                            , selected = upload$selected_df$gvhprhrx
          )

          # updateNumericInput(session
          #                    , "indxtx"
          #                    , value = upload$selected_df$indxtx
          # )
          updateSelectInput(session
                            , "invivotcd"
                            , selected = upload$selected_df$invivotcd
          )
    }) |> bindEvent(upload$upload_count)

    vals <- reactiveValues()
    observe({vals$df <- data.frame("yeartx"        = 2016
                                   ,"condclas"     = input$condclas
                                   ,"tbigp"        = input$tbigp
                                   ,"graftgp"      = input$graftgp
                                   ,"gvhprhrx"     = input$gvhprhrx
                                   ,"indxtx"       = 210
                                   ,"invivotcd"    = input$invivotcd
                                   )
    })
    return(vals)

  })
}

## To be copied in the UI
# mod_enter_transplant_ui("enter_transplant_1")

## To be copied in the server
# mod_enter_transplant_server("enter_transplant_1")
