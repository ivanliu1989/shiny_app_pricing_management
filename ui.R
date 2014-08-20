library(shiny)
library(ggplot2)  # for the diamonds dataset

shinyUI(navbarPage("AfterPlus Pricing Management", inverse = FALSE, collapsable = FALSE,
                   tabPanel("Summary"),
                   tabPanel("Detailed Report",
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
                            )),
                   navbarMenu("More",
                              tabPanel("Upload & Download Datasets"),
                              tabPanel("Market Information", 
                                       sidebarLayout(
                                           sidebarPanel(
                                               helpText("Select a stock to examine. Information will be collected from yahoo finance."),
                                               textInput("symb", "Symbol", "AUD"),
                                               dateRangeInput("dates", "Date range", 
                                                              start = "2014-01-01", 
                                                              end = as.character(Sys.Date())),
                                               actionButton("get", "Get Stock"),
                                               br(),br(),
                                               checkboxInput("log", "Plot y axis on log scale", value = FALSE),
                                               checkboxInput("adjust", "Adjust prices for inflation", value = FALSE)
                                               ),
                                           mainPanel(plotOutput("plot"))
                                           )
                                       )
                              )
                   )
        )