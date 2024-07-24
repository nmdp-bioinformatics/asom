#' predict_os UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_predict_os_ui <- function(id){
    ns <- NS(id)
    tagList(
        plotOutput(ns("plot_os"))
        ,tableOutput(ns("pred_tbl"))
    )
}

#' predict_os Server Functions
#' @import shiny
#' @import ggplot2
#' @noRd
mod_predict_os_server <- function(id, xtest, pyear){
    moduleServer( id, function(input, output, session){
        ns <- session$ns

        r <- reactiveValues(ptbl = NULL
                            ,plot = NULL
                            )

        ######## OS PREDICTIONS #########
        observe({
            preds <- predict(nft_os
                             , x.test = xtest$patdat_prep
                             , XPtr = FALSE
                             , K = 1
                             , events = pyear*365
                             , na.rm = TRUE
            )

            ptbl <- data.frame("dmale" = xtest$patdat_prep[,"dmale"]
                               ,"dage" = xtest$patdat_prep[,"urdbmpbdage"]
                               ,"mean"  = preds$surv.test.mean
                               ,"lower" = preds$surv.test.lower
                               ,"upper" = preds$surv.test.upper
            )
            ptbl$dmale <- factor(ptbl$dmale
                                 ,levels = c(0,1)
                                 ,labels = c("Female", "Male")
            )

            ptbl$pred <- paste0(sprintf("%.3f", ptbl$mean)
                                ,", ["
                                ,sprintf("%.3f", ptbl$lower)
                                ,", "
                                ,sprintf("%.3f", ptbl$upper)
                                ,"]"
            )

            ptbl_m <- subset(ptbl, dmale == "Male")
            ptbl_f <- subset(ptbl, dmale == "Female")

            ptbl_w  <- merge(ptbl_m[,c("dage", "pred")]
                             ,ptbl_f[,c("dage", "pred")]
                             ,by = "dage"
                             ,suffixes = c("_m", "_f")
            )
            ptbl_w <- ptbl_w[order(ptbl_w$dage),]
            ptbl_w$dage <- sprintf("%.0f", ptbl_w$dage)
            ptbl_w <- ptbl_w[,c("dage", "pred_m", "pred_f")]
            names(ptbl_w) <- c("Donor Age"
                               ,"Male Donor"
                               ,"Female Donor"
            )

            p <- ggplot(data = ptbl
                        ,aes(x = dage
                             , y = mean
                             , ymin = lower
                             , ymax = upper
                             , shape = dmale
                             , color = dmale
                             , group = dmale
                        )
            ) +
                geom_point(position = position_dodge(width = 1), size = 2) +
                # geom_line(position = position_dodge(width = 1)) +
                geom_errorbar(position = position_dodge(width = 1), size = 0.8) +
                scale_x_continuous(limits = c(16,62), breaks = seq(18,60,2)) +
                scale_y_continuous(limits = c(0,1), breaks = seq(0,1,0.1)) +
                ylab(paste0(pyear, "-Year Overall Survival\n")) +
                xlab("\nDonor Age") +
                scale_color_manual(name = "Donor Sex", values = c("tomato", "dodgerblue")) +
                scale_shape_manual(name = "Donor Sex", values = c(19,17)) +
                theme_bw() +
                theme(panel.grid.major.x = element_blank()
                      ,panel.grid.minor.x = element_blank()
                )

            r$ptbl <- ptbl_w
            r$plot <- p
        })

        output$plot_os <- renderPlot({
            r$plot
        })
        output$pred_tbl <- renderTable({
            r$ptbl
        }
        ,align = "lcc"
        ,striped = TRUE
        )

        return(r)

    })
}

## To be copied in the UI
# mod_predict_os_ui("predict_os_1")

## To be copied in the server
# mod_predict_os_server("predict_os_1")
