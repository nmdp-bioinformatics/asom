#' export_report UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_export_report_ui <- function(id){
    ns <- NS(id)
    tagList(
        uiOutput(outputId = ns("insert_button"))
    )
}

#' export_report Server Functions
#'
#' @noRd
mod_export_report_server <- function(id, predout_os, predout_efs, patprofile){
    moduleServer( id, function(input, output, session){
        ns <- session$ns

        output$insert_button <- renderUI({
            if (!is.null(predout_os$plot)){
                downloadButton(outputId = ns("report")
                               ,label = "Export report"
                )
            }
        })


        output$report <- downloadHandler(

            # For PDF output, change this to "report.pdf"
            filename = "report.html"

            ,content = function(file) {
                # Copy the report file to a temporary directory before processing it, in
                # case we don't have write permissions to the current working dir (which
                # can happen when deployed).
                # tempReport <- file.path(tempdir(), "report.Rmd")
                # file.copy("report.Rmd", tempReport, overwrite = TRUE)

                # Set up parameters to pass to Rmd document
                params <- list(ptbl_os = predout_os$ptbl
                               ,plot_os = predout_os$plot
                               ,ptbl_efs = predout_efs$ptbl
                               ,plot_efs = predout_efs$plot
                               ,patprofile = patprofile$patdat_clean
                               )

                # Knit the document, passing in the `params` list, and eval it in a
                # child of the global environment (this isolates the code in the document
                # from the code in this app).
                rmarkdown::render("R/report.Rmd"
                                  , output_file = file
                                  , params = params
                                  , envir = new.env(parent = globalenv())
                )
            })
    })
}

## To be copied in the UI
# mod_export_report_ui("export_report_1")

## To be copied in the server
# mod_export_report_server("export_report_1")
