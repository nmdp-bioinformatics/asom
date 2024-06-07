#' save_patprofile UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_save_patprofile_ui <- function(id){
  ns <- NS(id)
  tagList(
        downloadButton(outputId = ns("export_patdat")
                       ,label = "Save patient profile"
        )
  )
}

#' save_patprofile Server Functions
#'
#' @noRd
mod_save_patprofile_server <- function(id, patdat){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    output$export_patdat <- downloadHandler(
          filename = function() {
                paste("patient_profile_", Sys.Date(), ".RDS", sep="")
          },
          content = function(file) {
                saveRDS(patdat$patdat, file)
          }
    )
  })
}

## To be copied in the UI
# mod_save_patprofile_ui("save_patprofile_1")

## To be copied in the server
# mod_save_patprofile_server("save_patprofile_1")
