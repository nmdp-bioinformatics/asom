
linebreaks <- function(n){HTML(strrep(br(), n))}

waiter::waiter_set_theme(html = waiter::spin_3()
                         , color = "dimgray"
                         , logo = ""
                         , image = ""
                         )

options(mc.cores = 8)

# load data:
zcta_hhinc     <- readRDS(file = "data/zcta_hhinc.RDS")
patdat_default <- readRDS(file = "data/patdat_default.RDS")
xtest_names    <- readRDS(file = "data/xtest_vnames.RDS")
dat_fmtfun     <- readRDS(file = "data/dat_fmtfun.RDS")

nft_os  <- readRDS(file = "data/deadcounter.rds")
nft_efs <- readRDS(file = "data/efscounter.rds")

#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import bslib
#' @import waiter
#' @import shinyBS
#' @import shinyjs
#' @import ggplot2
#' @import nftbart
#' @import flextable
#' @noRd
app_ui <- function(request) {
    tagList(
        # Leave this function for adding external resources
        golem_add_external_resources()
        ,shinyjs::useShinyjs()

        # Your application UI logic
        ,fluidPage(

            # theme = bs_theme(version = 5, bootswatch= "flatly", font_scale = 1.25)
            autoWaiter()

            # header:
            ,h2("ASOM: Age/Sex Optimal Matching")
            ,linebreaks(1)
            ,"An R Shiny Application for "
            ,tags$a(href = "https://www.medrxiv.org/content/10.1101/2024.05.09.24307134v1.full-text"
                    ,"Optimal Donor Selection Across Multiple Outcomes For Hematopoietic Stem Cell Transplantation By Bayesian Nonparametric Machine Learning"
                    )
            ,hr()

            ,sidebarLayout(
                sidebarPanel(h4("Enter recipient characteristics and then press 'Predict!' below to generate predictions.")
                             ,h6("Note predictions may take several minutes to generate.")
                             ,bslib::input_task_button(id = "predict"
                                                       ,label = "Predict!"
                                                       )
                             ,hr()
                             ,uiOutput(outputId = "insert_exreport")
                             )
                ,mainPanel(
                    tabsetPanel(type = "tabs"
                                 ,tabPanel("Recipient Characteristics"
                                           ,h3("Enter Recipient Characteristics:")
                                           ,shinyBS::bsCollapse(id = "collapseRecip"
                                                                # ,open = "Enter Demographics"
                                                                ,shinyBS::bsCollapsePanel(title = "Enter Demographics"
                                                                                          ,value = 1
                                                                                          ,style = "info"
                                                                                          ,mod_enter_demo_ui("demo")
                                                                )
                                                                ,shinyBS::bsCollapsePanel(title = "Enter Disease Characteristics"
                                                                                          ,value = 2
                                                                                          ,style = "success"
                                                                                          ,mod_enter_disease_ui("disease")
                                                                )
                                                                ,shinyBS::bsCollapsePanel(title = "Enter Transplant Characteristics"
                                                                                          ,value = 3
                                                                                          ,style = "warning"
                                                                                          ,mod_enter_transplant_ui("transplant")
                                                                )
                                           )
                                           ,fluidRow(column(width = 8, mod_upload_patprofile_ui("upload_patdat"))
                                                    ,column(width = 4, mod_save_patprofile_ui("save_patdat"))
                                                    )
                                           ) # end main panel recipient tab
                                 ,tabPanel("Donor Characteristics"
                                           ,h3("Enter Donor Characteristics:")
                                           ,h6("Specify the donor ages you would like to make predictions for.")
                                           ,mod_enter_donor_ui("donor")
                                           ) # end main panel donor tab
                    ) # end tab panel
                ) # end main panel
            ) # end sidebar layout

            ,mod_assemble_patprofile_ui("patdat")
            ,mod_clean_patprofile_ui("patdatc")

            ,h3("Predictions:")
            ,tabsetPanel(type = "tabs"
                         ,tabPanel("1-Year Overall Survival"
                                   ,mod_predict_os_ui("predict1_os")
                                   )
                         ,tabPanel("1-Year Event Free Survival"
                                   ,mod_predict_efs_ui("predict1_efs")
                                   )
                         ,tabPanel("3-Year Overall Survival"
                                   ,mod_predict_os_ui("predict3_os")
                                   )
                         ,tabPanel("3-Year Event Free Survival"
                                   ,mod_predict_efs_ui("predict3_efs")
                                   )
                         )
        ) # end fluid page
    ) # end taglist
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
    add_resource_path(
        "www",
        app_sys("app/www")
    )

    tags$head(
        favicon(),
        bundle_resources(
            path = app_sys("app/www"),
            app_title = "nmdp.asom"
        )
        # Add here other external resources
        # for example, you can add shinyalert::useShinyalert()
    )
}
