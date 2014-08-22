library(shiny)
library(quantmod)
source("helpers.R")
library(ggplot2)
require(rCharts)
library(xlsx)
shinyServer(function(input,output){
    ## Summary
    output$myChart1 <- renderChart({
        names(iris) = gsub("\\.", "", names(iris))
        p1 <- rPlot(input$x, input$y, data = iris, color = "Species", 
                    facet = "Species", type = 'point')
        p1$set(xScale='ordinal',yScale='linear',width=600)
        p1$addParams(dom = 'myChart1')
        return(p1)
    })
    output$myChart2 <- renderChart({
        map3 <- Leaflet$new()
        map3$set(xScale='ordinal',yScale='linear',width=600)
        map3$setView(c(51.505, -0.09), zoom = 13)
        map3$marker(c(51.5, -0.09), bindPopup = "<p> Hi. I am a popup </p>")
        map3$marker(c(51.495, -0.083), bindPopup = "<p> Hi. I am another popup </p>")
        map3$addParams(dom = 'myChart2')
        return(map3)
    })
    ## Detailed Report
    output$mytable1 <- renderDataTable({
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
    
    ## Upload Datasets
    output$contents <- renderTable({
        # input$file1 will be NULL initially. After the user selects
        # and uploads a file, it will be a data frame with 'name',
        # 'size', 'type', and 'datapath' columns. The 'datapath'
        # column will contain the local filenames where the data can
        # be found.
        
        inFile <- input$file1
        
        if (is.null(inFile))
            return(NULL)
        
        read.xlsx(inFile$datapath, sheetIndex=input$sht, header = input$header)
    })
    
    ## Download Datasets
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
    
    
}
)