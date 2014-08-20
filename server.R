library(shiny)
library(quantmod)
source("helpers.R")

shinyServer(function(input,output){
    ## Detailed Report
    output$mytable1 <- renderDataTable({
        library(ggplot2)
        diamonds[, input$show_vars_tb1, drop = FALSE]
    }, options = list(bSortClasses = TRUE, aLengthMenu = c(5, 15, 30), iDisplayLength = 5))
    output$mytable2 <- renderDataTable({
        mtcars[, input$show_vars_tb2, drop = FALSE]
    }, options = list(bSortClasses = TRUE, aLengthMenu = c(5, 15, 30), iDisplayLength = 5))
    
    ## Market Information
    dataInput <- reactive({  
        getSymbols(input$symb, src = "yahoo", 
                   from = input$dates[1],
                   to = input$dates[2],
                   auto.assign = FALSE)
    })
    finalInput <- reactive({
        if (!input$adjust) return(dataInput())
        adjust(dataInput())
    })
    output$plot <- renderPlot({
        chartSeries(finalInput(), theme = chartTheme("white"), 
                    type = "line", log.scale = input$log, TA = NULL)
    })
}
)