#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinyBS
#' @import ggplot2
#' @noRd
app_server <- function(input, output, session) {
      # Your application server logic

      # module for uploading a previous RDS patient profile:
      upload_status <- mod_upload_patprofile_server("upload_patdat")

      # ui modules for entering demo, dx, tx characteristics:
      demo <- mod_enter_demo_server("demo", upload = upload_status)
      dx   <- mod_enter_disease_server("disease", upload = upload_status)
      tx   <- mod_enter_transplant_server("transplant", upload = upload_status)

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
      observe({
            message("collapsing...")
            shinyBS::updateCollapse(session = session
                           ,id = "collapseRecip"
                           ,close = c(1,2,3)
            )
            message("collapsing done...")

            message("starting data prep...")
            pdatc <- mod_clean_patprofile_server("patdatc", patdat = pdat, pred_button = input$predict)
            message("data prep done...")

            message("starting OS predictions...")
            preds_os <- mod_predict_os_server("predict_os", xtest = pdatc)
            message("OS predictions done...")

            message("starting EFS predictions...")
            preds_efs <- mod_predict_efs_server("predict_efs", xtest = pdatc)
            message("EFS predictions done...")

            mod_export_report_server("exreport"
                                     , predout_os = preds_os
                                     , predout_efs = preds_efs
                                     , patprofile = pdatc
                                     )

      }) |> bindEvent(input$predict)

}
