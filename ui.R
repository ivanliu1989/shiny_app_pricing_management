library(shiny)
library(ggplot2)  # for the diamonds dataset

shinyUI(fluidPage(
    headerPanel("AfterPlus Pricing Management"),
    sidebarLayout(
        sidebarPanel(
            conditionalPanel(
                'input.dataset === "Dongdamen"',
                checkboxGroupInput('show_vars_tb1','Columns in Dongdamen to show:',
                                   names(diamonds), selected = names(diamonds))
                ),
            conditionalPanel(
                'input.dataset === "GongCha"',
                checkboxGroupInput('show_vars_tb2','Columns in Dongdamen to show:',
                                   names(mtcars), selected = names(mtcars))
                )
            ),
        mainPanel(
            tabsetPanel(
                id='dataset',
                tabPanel('Dongdamen', dataTableOutput('mytable1')),
                tabPanel('GongCha', dataTableOutput('mytable2'))
                )
            )
        )
    )
)