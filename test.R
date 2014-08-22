setwd(choose.dir())
require(xlsx)

profits <- 0.3
exchangeRate <- 5.8

ap <- read.xlsx("CAT2.xlsx",1,encoding = "UTF-8",stringsAsFactors=FALSE,shee)
ap <- ap[,-8]
if((ap$Currency == 'CNY'))
    ap[,c(4,6)]<- ap[,c(4,6)]/exchangeRate
ap$Cost <- ap$Unit.Cost + ap$Postage
ap$Total.Cost <- ap$Cost * ap$Qty 
ap$Sale.Price <- ap$Cost * (profits+1)
ap$Unit.Margin <- ap$Sale.Price - ap$Cost


head(ap)

read.xlsx("CAT2.xlsx", sheetIndex=1, header = T 
          #                  sep = input$sep, quote = input$quote
)