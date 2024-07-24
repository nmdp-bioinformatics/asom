#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinyBS
#' @import shinyjs
#' @import ggplot2
#' @noRd
app_server <- function(input, output, session) {
      # Your application server logic

      # module for uploading a previous RDS patient profile:
      upload_status <- mod_upload_patprofile_server("upload_patdat")

      # ui modules for entering demo, dx, tx characteristics:
      demo  <- mod_enter_demo_server("demo", upload = upload_status)
      dx    <- mod_enter_disease_server("disease", upload = upload_status)
      tx    <- mod_enter_transplant_server("transplant", upload = upload_status)
      donor <- mod_enter_donor_server("donor")

      # assemble patient profile data to use in prediction model:
      pdat <- mod_assemble_patprofile_server("patdat"
                                            , demo_dat = demo
                                            , dx_dat = dx
                                            , tx_dat = tx
                                            )

      # button to save patient profile:
      mod_save_patprofile_server("save_patdat", patdat = pdat)

      # when predict button is pushed:
      # - data entry windows are all collapsed
      # - data is prepped
      # - predictions are generated
      # - export report button appears

      r <- reactiveValues(pdatc = NULL
                          ,preds1_os = NULL
                          ,preds1_efs = NULL
                          ,preds3_os = NULL
                          ,preds3_efs = NULL
                          )
      observe({

            shinyjs::hide("exreport")

            message("collapsing panels...")
            shinyBS::updateCollapse(session = session
                           ,id = "collapseRecip"
                           ,close = c(1,2,3)
            )
            shinyBS::updateCollapse(session = session
                                    ,id = "collapseDonor"
                                    ,close = 1
                                    )
            message("collapsing done...")

            message("starting data prep...")
            pdatc <- mod_clean_patprofile_server("patdatc"
                                                 , patdat = pdat
                                                 , pred_button = input$predict
                                                 , dondat = donor
                                                 )
            r$pdatc <- pdatc
            message("data prep done...")

            message("starting 1-year predictions...")
            r$preds1_os  <- mod_predict_os_server("predict1_os"  , xtest = pdatc, pyear = 1)
            r$preds1_efs <- mod_predict_efs_server("predict1_efs", xtest = pdatc, pyear = 1)
            message("1-year predictions done...")

            message("starting 3-year predictions...")
            r$preds3_os  <- mod_predict_os_server("predict3_os"  , xtest = pdatc, pyear = 3)
            r$preds3_efs <- mod_predict_efs_server("predict3_efs", xtest = pdatc, pyear = 3)
            message("3-year predictions done...")

            output$insert_exreport <- renderUI({
                downloadButton(outputId = "exreport"
                               ,label = "Export report"
                )
            })

      })  |> bindEvent(input$predict)


      output$exreport <- downloadHandler(
          filename = "asom_report.html"
          ,content = function(file) {
              # Set up parameters to pass to Rmd document
              params <- list(ptbl1_os = r$preds1_os$ptbl
                             ,plot1_os = r$preds1_os$plot
                             ,ptbl1_efs = r$preds1_efs$ptbl
                             ,plot1_efs = r$preds1_efs$plot

                             ,ptbl3_os = r$preds3_os$ptbl
                             ,plot3_os = r$preds3_os$plot
                             ,ptbl3_efs = r$preds3_efs$ptbl
                             ,plot3_efs = r$preds3_efs$plot

                             ,patprofile = r$pdatc$patdat_clean
              )
              rmarkdown::render("R/report.Rmd"
                                , output_file = file
                                , params = params
                                , envir = new.env(parent = globalenv())
              )
          })

}
