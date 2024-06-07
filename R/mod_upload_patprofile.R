#' upload_patprofile UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_upload_patprofile_ui <- function(id){
      ns <- NS(id)
      tagList(
            fileInput(inputId  = ns("user_patdat")
                      ,label = NULL
                      ,accept = ".RDS"
                      ,buttonLabel = "Upload patient profile"
                      )
            )
}

#' upload_patprofile Server Functions
#'
#' @noRd
mod_upload_patprofile_server <- function(id){
      moduleServer( id, function(input, output, session){
            ns <- session$ns

            r <- reactiveValues(selected_df = patdat_default
                                ,upload_count = 0
                                )

            observe({
                  file <- input$user_patdat
                  ext <- tools::file_ext(file$datapath)

                  req(file)
                  validate(need(ext == "RDS", "Please upload an RDS file"))

                  r$selected_df <- readRDS(file$datapath)
                  r$upload_count <- r$upload_count + 1

            }) |> bindEvent(input$user_patdat)

            return(r)
      })
}

## To be copied in the UI
# mod_upload_patprofile_ui("upload_patprofile_1")

## To be copied in the server
# mod_upload_patprofile_server("upload_patprofile_1")
