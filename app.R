library(shiny)
library(shinydashboard)
library(quantmod)
library(PerformanceAnalytics)
library(PortfolioAnalytics)
library(ROI)
library(ROI.plugin.quadprog)
library(DT)
library(ggplot2)
library(plotly)
library(TSstudio)
library(corrplot)

ui <- dashboardPage(
  dashboardHeader(title = "Portfolio Optimization Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Stock Prices", tabName = "prices", icon = icon("chart-line")),
      menuItem("Returns", tabName = "returns", icon = icon("chart-area")),
      menuItem("Optimization", tabName = "opt", icon = icon("balance-scale")),
      menuItem("VaR", tabName = "var", icon = icon("exclamation-triangle"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "prices",
              fluidRow(
                box(title = "Stock Price Visualization", status = "primary", solidHeader = TRUE, width = 12,
                    plotlyOutput("pricePlot"))
              )
      ),
      tabItem(tabName = "returns",
              fluidRow(
                box(title = "Return Table", status = "primary", solidHeader = TRUE, width = 6,
                    dataTableOutput("returnTable")),
                box(title = "Returns Plot", status = "primary", solidHeader = TRUE, width = 6,
                    plotlyOutput("returnPlot"))
              )
      ),
      tabItem(tabName = "opt",
              fluidRow(
                box(title = "Efficient Frontier", status = "primary", solidHeader = TRUE, width = 6,
                    plotOutput("frontierPlot")),
                box(title = "Sharpe Ratios", status = "primary", solidHeader = TRUE, width = 6,
                    plotOutput("sharpePlot"))
              )
      ),
      tabItem(tabName = "var",
              fluidRow(
                box(title = "Value at Risk Table", status = "primary", solidHeader = TRUE, width = 12,
                    dataTableOutput("varTable"))
              )
      )
    )
  )
)

server <- function(input, output, session) {
  top_stocks <- c("AAPL", "MSFT", "GOOGL", "AMZN", "META", "TSLA", "BRK-B", "JPM", "V", "JNJ", "NVDA", "PG", "UNH", "BAC", "MA")
  new.data <- list()
  for (stock_symbol in top_stocks) {
    try(getSymbols(stock_symbol, from = Sys.Date() - 729, to = Sys.Date(), src = "yahoo", auto.assign = TRUE), silent = TRUE)
    new.data[[stock_symbol]] <- get(stock_symbol)[,6] # Adjusted prices
  }
  combined.data <- do.call(merge, new.data)
  colnames(combined.data) <- top_stocks
  
  returns <- na.omit(Return.calculate(combined.data))
  covmat <- cov(returns) * 252
  mu <- colMeans(returns) * 252
  
  rf <- getSymbols("^IRX", from = Sys.Date() - 729, to = Sys.Date(), auto.assign = FALSE)[,6]
  rf.rate <- prod(1 + na.omit(rf)/9000)^(1/length(na.omit(rf))) - 1
  rf.annual <- rf.rate * 252
  
  output$pricePlot <- renderPlotly({
    p <- ts_plot(combined.data, title = "Stock Prices")
    ggplotly(p)
  })
  
  output$returnTable <- renderDataTable({
    datatable(as.data.frame(round(returns, 4)))
  })
  
  output$returnPlot <- renderPlotly({
    p <- ts_plot(returns, title = "Daily Returns")
    ggplotly(p)
  })
  
  output$frontierPlot <- renderPlot({
    ef <- efficient.frontier(mu, covmat, alpha.min = -2.5, alpha.max = 5, nport = 20)
    plot(ef, plot.assets = TRUE, col = "maroon")
  })
  
  output$sharpePlot <- renderPlot({
    ann.ret <- colMeans(returns) * 252
    ann.rsk <- apply(returns, 2, sd) * sqrt(252)
    sharpe <- (ann.ret - rf.annual) / ann.rsk
    df <- data.frame(Symbol = names(sharpe), Sharpe = sharpe)
    ggplot(df, aes(x = Symbol, y = Sharpe)) +
      geom_bar(stat = "identity", fill = "brown") +
      theme_minimal() +
      labs(title = "Sharpe Ratios")
  })
  
  output$varTable <- renderDataTable({
    set.seed(123456)
    w <- runif(ncol(returns))
    w <- w / sum(w)
    mu.p <- sum(mu * w)
    sig.p <- sqrt(t(w) %*% covmat %*% w)
    VaR <- -1000000 * (mu.p + sig.p * qnorm(0.05))
    var_df <- data.frame(Asset = c(colnames(returns), "Portfolio"), VaR = round(c(-1000000 * (mu + diag(covmat)^0.5 * qnorm(0.05)), VaR), 2))
    datatable(var_df)
  })
}

shinyApp(ui, server)
