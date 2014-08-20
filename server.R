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
    
    ## Upload & Download Datasets
    datasetInput <- reactive({
        switch(input$dataset,
               "rock" = rock,
               "pressure" = pressure,
               "cars" = cars)
    })
    
    output$table <- renderTable({
        datasetInput()
    })
    
    output$downloadData <- downloadHandler(
        filename = function() { paste(input$dataset, '.csv', sep='') },
        content = function(file) {
            write.csv(datasetInput(), file)
        }
    )
    
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