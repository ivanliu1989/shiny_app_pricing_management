library(shiny)

shinyServer(function(input,output){
    
    output$mytable1 <- renderDataTable({
        library(ggplot2)
        diamonds[, input$show_vars_tb1, drop = FALSE]
    }, options = list(bSortClasses = TRUE, aLengthMenu = c(5, 15, 30), iDisplayLength = 5))
    
    output$mytable2 <- renderDataTable({
        mtcars[, input$show_vars_tb2, drop = FALSE]
    }, options = list(bSortClasses = TRUE, aLengthMenu = c(5, 15, 30), iDisplayLength = 5))    
}
)