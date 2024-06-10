#' assemble_patprofile UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_assemble_patprofile_ui <- function(id){
  ns <- NS(id)
  tagList(
    # h3("Patient data updated live as entered:")
    # ,DT::DTOutput(ns("patdat_rdt"))
  )
}

#' assemble_patprofile Server Functions
#'
#' @noRd
mod_assemble_patprofile_server <- function(id, demo_dat, dx_dat, tx_dat){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    r <- reactiveValues(patdat = NULL)

    observe({

      r$patdat <- data.frame(demo_dat$df
                             ,dx_dat$df
                             ,tx_dat$df
                             )

    })

    output$patdat_rdt <- DT::renderDT({
      r$patdat
    })

    return(r)
  })


}

## To be copied in the UI
# mod_assemble_patprofile_ui("assemble_patprofile_1")

## To be copied in the server
# mod_assemble_patprofile_server("assemble_patprofile_1")
