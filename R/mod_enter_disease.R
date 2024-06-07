#' enter_disease UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_enter_disease_ui <- function(id){
  ns <- NS(id)
  tagList(
    h3("Disease Specific Characteristics:")
    ,selectInput(inputId = ns("disease")
                ,label = "Disease"
                ,choices = list("AML" = 10
                                ,"ALL" = 20
                                ,"Other leukemia" = 30
                                ,"CML" = 40
                                ,"MDS/MF" = 50
                                ,"MPN" = 51
                                ,"Other acute leukemia" = 80
                                ,"NHL" = 100
                                ,"HD" = 150
                                ,"PCD" = 170
                                ,"SAA" = 300
                                ,"IEA" = 310
                                ,"IIS" = 400
                                ,"Other non-malignant" = 900
                                ," " = 99
                )
                ,selected = 99
    )

    # troubleshooting ns issues of confitionalPanels within a module:
    # https://github.com/rstudio/shiny/issues/1586
    # https://shiny.posit.co/r/articles/improve/modules/

    ,conditionalPanel(
      condition = paste0("input['", ns("disease"), "'] == 10")
      ,mod_enter_disease_aml_ui(ns("aml"))
    )
    ,conditionalPanel(
      condition = paste0("input['", ns("disease"), "'] == 20")
      ,mod_enter_disease_all_ui(ns("all"))
    )
    ,conditionalPanel(
      condition = paste0("input['", ns("disease"), "'] == 30")
      ,mod_enter_disease_cll_ui(ns("cll"))
    )
    ,conditionalPanel(
      condition = paste0("input['", ns("disease"), "'] == 40")
      ,mod_enter_disease_cml_ui(ns("cml"))
    )
    ,conditionalPanel(
      condition = paste0("input['", ns("disease"), "'] == 50")
      ,mod_enter_disease_mds_ui(ns("mds"))
    )
    ,conditionalPanel(
      condition = paste0("input['", ns("disease"), "'] == 170")
      ,mod_enter_disease_mm_ui(ns("mm"))
    )
    ,conditionalPanel(
      condition = paste0("input['", ns("disease"), "'] == 100")
      ,mod_enter_disease_nhl_ui(ns("nhl"))
    )
    ,conditionalPanel(
      condition = paste0("input['", ns("disease"), "'] == 150")
      ,mod_enter_disease_hd_ui(ns("hd"))
    )
  )
}

#' enter_disease Server Functions
#'
#' @noRd
mod_enter_disease_server <- function(id, upload){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observe({
          updateSelectInput(session
                            , "disease"
                            , selected = upload$selected_df$disease
          )
    })

    dx_all <- mod_enter_disease_all_server("all", upload_dxsub = upload)
    dx_aml <- mod_enter_disease_aml_server("aml", upload_dxsub = upload)
    dx_cll <- mod_enter_disease_cll_server("cll", upload_dxsub = upload)
    dx_cml <- mod_enter_disease_cml_server("cml", upload_dxsub = upload)
    dx_mds <- mod_enter_disease_mds_server("mds", upload_dxsub = upload)
    dx_mm  <- mod_enter_disease_mm_server("mm", upload_dxsub = upload)
    dx_nhl <- mod_enter_disease_nhl_server("nhl", upload_dxsub = upload)
    dx_hd  <- mod_enter_disease_hd_server("hd", upload_dxsub = upload)

    vals <- reactiveValues(df = NULL)
    observe({

      vals$df <- data.frame("disease" = input$disease
                             ,dx_all$df
                             ,dx_aml$df
                             ,dx_cll$df
                             ,dx_cml$df
                             ,dx_mds$df
                             ,dx_mm$df
                             ,dx_nhl$df
                             ,dx_hd$df
                            )

    })
    return(vals)

  })
}

## To be copied in the UI
# mod_enter_disease_ui("enter_disease_1")

## To be copied in the server
# mod_enter_disease_server("enter_disease_1")
