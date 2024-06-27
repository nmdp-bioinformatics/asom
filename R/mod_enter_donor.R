#' enter_donor UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_enter_donor_ui <- function(id){
  ns <- NS(id)
  tagList(
      sliderInput(inputId = ns("dage_range")
                  ,label = "Donor age range (years)"
                  ,min = 18
                  ,max = 60
                  ,value = c(18, 60)
                  ,step = 1
      )
      ,selectInput(inputId = ns("dage_step")
                  ,label = "Donor age interval"
                  ,choices = list("1-year" = 1
                                  ,"2-year" = 2
                                  ,"3-year" = 3
                                  ,"4-year" = 4
                                  )
                  ,selected = 4
      )
      # ,linebreaks(1)
      ,h6("Predictions will be made for the following donor ages:")
      ,textOutput(ns("dages"))
  )
}

#' enter_donor Server Functions
#'
#' @noRd
mod_enter_donor_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    vals <- reactiveValues()
    observe({
        vals$dages <- seq(from = input$dage_range[1]
                          ,to = input$dage_range[2]
                          ,by = as.numeric(input$dage_step)
                          )
    })


    output$dages <- renderText({
        paste(vals$dages, collapse = ", ")
    })

    return(vals)

  })
}

## To be copied in the UI
# mod_enter_donor_ui("enter_donor_1")

## To be copied in the server
# mod_enter_donor_server("enter_donor_1")
