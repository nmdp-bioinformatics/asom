#' clean_patprofile UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_clean_patprofile_ui <- function(id){
      ns <- NS(id)
      tagList(
            # h3("Patient data after data cleaning")
            #
            # ,downloadButton(outputId = ns("export_patdat_clean")
            #                 ,label = "Save cleaned data"
            # )
            # ,DT::DTOutput(ns("patdatc_rdt"))
            #
            # ,h3("Patient data after prep for modeling")
            # ,downloadButton(outputId = ns("export_patdat_prep")
            #                 ,label = "Save prepped data"
            # )
            # ,DT::DTOutput(ns("patdatp_rdt"))
      )
}

#' clean_patprofile Server Functions
#'
#' @noRd
mod_clean_patprofile_server <- function(id, patdat, pred_button, dondat){
      moduleServer( id, function(input, output, session){
            ns <- session$ns

            r <- reactiveValues(patdat_clean = NULL
                                ,patdat_prep = NULL
            )

            observe({

                  patdatc <- patdat$patdat

                  ### make disease specific variables -1 if not applicable for selected disease:
                  if (patdatc$disease == 99) patdatc$disease <- 10
                  if (patdatc$disease != 10) {
                        patdatc[,c("cytogeneaml", "mdstfaml", "amlrxrel", "aldist_aml", "indcycle_aml")] <- -1
                  }
                  if (patdatc$disease != 20) {
                        patdatc[,c("philgp", "allsubgp", "cytogeneall", "bcrrespr", "aldist_all", "indcycle_all")] <- -1
                  }
                  if (patdatc$disease != 30) {
                        patdatc[,c("clldist", "cll17pab")] <- -1
                  }
                  if (patdatc$disease != 40) {
                        patdatc[,c("cmldist")] <- -1
                  }
                  if (patdatc$disease != 50) {
                        patdatc[,c("ipssrpr", "mdspredisp", "mdsrxrel")] <- -1
                  }
                  if (patdatc$disease != 100) {
                        patdatc[,c("lymresist_nhl", "lymsubgp")] <- -1
                  }
                  if (patdatc$disease != 170) {
                        patdatc[,c("mmissdsdx", "mmcytorisk", "mmdist")] <- -1
                  }
                  if (patdatc$disease != 150) {
                        patdatc[,c("lymresist_hd")] <- -1
                  }

                  ### set default values for any missing/unknown or invalid responses:
                  patdatc$age[is.na(patdatc$age)] <- patdat_default$age
                  patdatc$age[patdatc$age < 0   ] <- patdat_default$age
                  patdatc$age[patdatc$age > 100 ] <- patdat_default$age
                  patdatc$coorgscore[is.na(patdatc$coorgscore)] <- patdat_default$coorgscore
                  patdatc$coorgscore[patdatc$coorgscore < 0   ] <- patdat_default$coorgscore
                  patdatc$coorgscore[patdatc$coorgscore > 20  ] <- patdat_default$coorgscore
                  patdatc$karnofraw[is.na(patdatc$karnofraw)] <- patdat_default$karnofraw
                  patdatc$karnofraw[patdatc$karnofraw < 10  ] <- patdat_default$karnofraw
                  patdatc$karnofraw[patdatc$karnofraw > 100 ] <- patdat_default$karnofraw
                  # patdatc$indxtx[is.na(patdatc$indxtx)  ] <- patdat_default$indxtx
                  # patdatc$indxtx[patdatc$indxtx < 0     ] <- patdat_default$indxtx
                  # patdatc$indxtx[patdatc$indxtx > 100000] <- patdat_default$indxtx

                  patdatc[patdatc %in% 99] <- patdat_default[patdatc %in% 99]

                  ### collapse variables which have multiple applicable diseases:
                  patdatc$aldist    <- max(patdatc$aldist_aml   , patdatc$aldist_all  )
                  patdatc$indcycle  <- max(patdatc$indcycle_aml , patdatc$indcycle_all)
                  patdatc$lymresist <- max(patdatc$lymresist_nhl, patdatc$lymresist_hd)

                  ### look-up median HH income from zip code:
                  patdatc$median_income <- NA
                  if (patdatc$zipcode %in% zcta_hhinc$zip) {
                        patdatc$median_income <- subset(zcta_hhinc, zip == patdatc$zipcode)[,"median_income"]
                  }
                  patdatc$median_income[is.na(patdatc$median_income)] <- 61056

                  r$patdat_clean <- patdatc


                  ### PREP dataset for modeling ###
                  num_vars <- c("age")
                  fac_vars <- c('racegp', 'condclas', 'gvhprhrx', 'disease')
                  int_vars <- names(patdatc)[!(names(patdatc) %in% c(num_vars, fac_vars))]
                  for (i in 1:length(num_vars)){
                        patdatc[, num_vars[i]] <- as.numeric(patdatc[, num_vars[i]])
                  }
                  for (i in 1:length(int_vars)){
                        patdatc[, int_vars[i]] <- as.integer(patdatc[, int_vars[i]])
                  }
                  patdatc$racegp <- factor(patdatc$racegp
                                           ,levels = c("1", "2", "3", "5", "8")
                                           ,labels = c(as.character(1:5))
                  )
                  patdatc$condclas <- factor(patdatc$condclas
                                             ,levels = c("1", "2", "3")
                  )
                  patdatc$gvhprhrx <- factor(patdatc$gvhprhrx
                                             ,levels = c("2","4","6","7","8","10","11","12","14","20","60")
                                             ,labels = c(as.character(1:11))
                  )
                  patdatc$disease <- factor(patdatc$disease
                                            ,levels = c("10","20","30","40","50","51","80"
                                                        ,"100","150","170","300","310","400","900"
                                            )
                                            ,labels = c(as.character(1:14))
                  )

                  # Dummy code the factor variables:
                  patdatc2 <- fastDummies::dummy_cols(patdatc
                                                      ,select_columns = fac_vars
                                                      ,remove_selected_columns = TRUE
                  )
                  names(patdatc2) <- gsub("^disease_", "disease", names(patdatc2), fixed = F)
                  names(patdatc2) <- gsub("^gvhprhrx_", "gvhprhrx", names(patdatc2), fixed = F)
                  names(patdatc2) <- gsub("^condclas_", "condclas", names(patdatc2), fixed = F)
                  names(patdatc2) <- gsub("^racegp_", "racegp", names(patdatc2), fixed = F)

                  x.test1 <- patdatc2[1, ]
                  x.test2 <- x.test1

                  # donor ages for prediction:
                  # urdbmpbdage <- seq(18, 36, 2)
                  # urdbmpbdage <- c(seq(18, 40, 2), seq(44, 60, 4))
                  # urdbmpbdage <- seq(18, 60, 4)
                  urdbmpbdage <- dondat$dages

                  for (j in 2:length(urdbmpbdage)) {
                        x.test1 <- rbind(x.test1, x.test2)
                  }
                  x.test <- x.test1
                  x.test$urdbmpbdage <- urdbmpbdage
                  x.test <- rbind(x.test, x.test)
                  x.test$dmale <- rep(0:1, each = length(urdbmpbdage))

                  x.test <- as.matrix(x.test)

                  patdat_prep <- x.test[,xtest_names]

                  r$patdat_prep <- patdat_prep
            }) |> bindEvent(pred_button)

            output$patdatc_rdt <- DT::renderDT({
                  r$patdat_clean
            })
            output$patdatp_rdt <- DT::renderDT({
                  r$patdat_prep
            })

            output$export_patdat_clean <- downloadHandler(
                  filename = function() {
                        paste("patprofile_CLEAN_", Sys.Date(), ".RDS", sep="")
                  },
                  content = function(file) {
                        saveRDS(r$patdat_clean, file)
                  }
            )
            output$export_patdat_prep <- downloadHandler(
                  filename = function() {
                        paste("patprofile_PREP_", Sys.Date(), ".RDS", sep="")
                  },
                  content = function(file) {
                        saveRDS(r$patdat_prep, file)
                  }
            )

            return(r)
      })
}

## To be copied in the UI
# mod_clean_patprofile_ui("clean_patprofile_1")

## To be copied in the server
# mod_clean_patprofile_server("clean_patprofile_1")
