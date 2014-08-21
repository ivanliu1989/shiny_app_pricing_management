library(shiny)
library(quantmod)
source("helpers.R")
library(ggplot2)
require(rCharts)
shinyServer(function(input,output){
    ## Summary
    output$myChart <- renderChart({
        names(iris) = gsub("\\.", "", names(iris))
        p1 <- rPlot(input$x, input$y, data = iris, color = "Species", 
                    facet = "Species", type = 'point')
        p1$addParams(dom = 'myChart')
        return(p1)
    })
    
    ## Detailed Report
    output$mytable1 <- renderDataTable({
        diamonds[, input$show_vars_tb1, drop = FALSE]
    }, options = list(bSortClasses = TRUE, aLengthMenu = c(5, 15, 30), iDisplayLength = 5))
    output$mytable2 <- renderDataTable({
        mtcars[, input$show_vars_tb2, drop = FALSE]
    }, options = list(bSortClasses = TRUE, aLengthMenu = c(5, 15, 30), iDisplayLength = 5))
    
    ## Upload & Download Datasets
    datasetInput <- reactive({
        switch(input$dataset,
               "Dongdamen" = mtcars,
               "GJ" = rock)
    })
    
    output$table_download <- renderTable({
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