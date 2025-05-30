library(shiny)
library(shinydashboard)
library(plotly)
library(DT)

ui <- dashboardPage(
  dashboardHeader(title = "Portfolio Optimization Dashboard"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Overview", tabName = "overview", icon = icon("info-circle")),
      menuItem("Data Visualization", tabName = "data_viz", icon = icon("chart-line")),
      menuItem("Portfolio Analysis", tabName = "portfolio_analysis", icon = icon("chart-pie")),
      menuItem("Risk Management", tabName = "risk_management", icon = icon("bell")),
      menuItem("Comparisons", tabName = "comparisons", icon = icon("exchange-alt"))
    )
  ),
  
  dashboardBody(
    tabItems(
      
      # Overview Tab
      tabItem(tabName = "overview",
              h2("Welcome to the Portfolio Optimization Dashboard"),
              fluidRow(
                box(title = "Introduction", status = "primary", solidHeader = TRUE, width = 12,
                    p("This dashboard is authored by", strong("Godfrey Elia Nkolokosa"), " and it offers an interactive way of analysing popular stocks using the principles of portfolio theory. You will be able to explore historical stock prices, daily returns, key portfolio metrics, and portfolio optimization strategies."),
                    p(strong("Disclaimer:")," The author is not endorsing any of the stocks mentioned in the dashboard, and he explicitly forbids the use of this dashboard for making investment decisions. Remember, investing is risky, please consult finance professionals for investment advice"),
                    p("Navigate through the tabs on the left to delve deeper into various aspects of portfolio management.")
                )
              )
      ),
      
      # Data Visualization Tab
      tabItem(tabName = "data_viz",
              h2("Stock Data Visualization"),
              tabsetPanel(
                tabPanel("Adjusted Prices Plot",
                         fluidRow(
                           box(title = "Adjusted Stock Prices", status = "info", solidHeader = TRUE, width = 12,
                               plotlyOutput("stock_prices_plot"),
                               p("This chart displays the historical adjusted closing prices for the selected stocks over the last two years. Adjusted prices account for dividends and stock splits, providing a more accurate picture of returns.")
                           )
                         )
                ),
                tabPanel("Daily Returns Plot",
                         fluidRow(
                           box(title = "Daily Stock Returns", status = "info", solidHeader = TRUE, width = 12,
                               plotlyOutput("stock_returns_plot"),
                               p("This chart shows the daily percentage change in prices for each stock. Returns are crucial for understanding volatility and calculating portfolio performance.")
                           )
                         )
                ),
                tabPanel("Adjusted Prices Table",
                         fluidRow(
                           box(title = "Daily Adjusted Prices Table", status = "info", solidHeader = TRUE, width = 12,
                               DTOutput("adjusted_data_table"),
                               p("This table presents the raw historical adjusted closing prices for the stocks - these are the exact values used in the analysis.")
                           )
                         )
                ),
                tabPanel("Daily Returns Table",
                         fluidRow(
                           box(title = "Daily Stock Returns Table", status = "info", solidHeader = TRUE, width = 12,
                               DTOutput("returns_data_table"),
                               p("This table provides the calculated daily returns for each stock. Daily returns are a fundamental input for portfolio risk and return calculations.")
                           )
                         )
                )
              )
      ),
      
      # Portfolio Analysis Tab
      tabItem(tabName = "portfolio_analysis",
              h2("Portfolio Performance and Optimization"),
              tabsetPanel(
                tabPanel("Mean & Std Dev Table",
                         fluidRow(
                           box(title = "Average Annual Returns and Standard Deviations", status = "success", solidHeader = TRUE, width = 12,
                               DTOutput("mean_sd_table"),
                               p("This table shows the annualized average returns and standard deviations for each stock."),
                               p(strong("Average Annual Return:"), " The expected annual percentage gain from holding the stock."),
                               p(strong("Annualized Standard Deviation:"), " A measure of the stock's annual volatility or risk. Higher standard deviation implies higher risk.")
                           )
                         )
                ),
                tabPanel("Covariance Matrix",
                         fluidRow(
                           box(title = "Annualized Covariance Matrix", status = "success", solidHeader = TRUE, width = 12,
                               DTOutput("covariance_table"),
                               p("The covariance matrix shows how the returns of different assets move together."),
                               p(strong("Covariance:"), " A statistical measure indicating the extent to which two assets' returns move in tandem.")
                           )
                         )
                ),
                tabPanel("Efficient Frontier Plot",
                         fluidRow(
                           box(title = "Efficient Frontier", status = "success", solidHeader = TRUE, width = 12,
                               plotlyOutput("efficient_frontier_plot"),
                               p("The efficient frontier is a set of optimal portfolios that offer the highest expected return for a given level of risk or the lowest risk for a given level of expected return.")
                           )
                         )
                ),
                tabPanel("Target Risk Portfolio Weights",
                         fluidRow(
                           box(title = "Optimal Portfolio Weights (Target Risk Tolerance)", status = "success", solidHeader = TRUE, width = 6,
                               DTOutput("optimal_weights_table"),
                               p("This table displays the optimal weights for each asset in a portfolio designed for a specific risk tolerance.")
                           ),
                           box(title = "Optimal Portfolio Weights Chart", status = "success", solidHeader = TRUE, width = 6,
                               plotlyOutput("optimal_weights_chart"),
                               p("This chart visually represents the allocation of funds to each security for the target risk tolerance portfolio.")
                           )
                         )
                ),
                tabPanel("Tangency Portfolio Weights",
                         fluidRow(
                           box(title = "Tangency Portfolio Weights", status = "success", solidHeader = TRUE, width = 6,
                               DTOutput("tangency_weights_table"),
                               p("This table shows the optimal weights for assets in the Tangency Portfolio.")
                           ),
                           box(title = "Tangency Portfolio Weights Chart", status = "success", solidHeader = TRUE, width = 6,
                               plotlyOutput("tangency_weights_chart"),
                               p("This chart visually represents the allocation of funds to each security for the Tangency Portfolio.")
                           )
                         )
                )
              )
      ),
      
      # Risk Management Tab
      tabItem(tabName = "risk_management",
              h2("Risk Management Metrics"),
              tabsetPanel(
                tabPanel("Value at Risk (VaR)",
                         fluidRow(
                           box(title = "Value at Risk (VaR)", status = "danger", solidHeader = TRUE, width = 12,
                               DTOutput("var_table"),
                               p("Value at Risk (VaR) is a measure of the potential loss in value of a portfolio over a defined period for a given confidence interval.")
                           )
                         )
                ),
                tabPanel("Sharpe Ratios",
                         fluidRow(
                           box(title = "Sharpe Ratios of Individual Stocks", status = "danger", solidHeader = TRUE, width = 12,
                               plotlyOutput("sharpe_ratio_plot"),
                               p("The Sharpe Ratio measures the risk-adjusted return of an investment.")
                           )
                         )
                ),
                tabPanel("Correlation Matrix",
                         fluidRow(
                           box(title = "Asset Correlation Matrix", status = "danger", solidHeader = TRUE, width = 12,
                               plotOutput("correlation_plot"),
                               p("The correlation matrix displays the correlation coefficients between the returns of different assets.")
                           )
                         )
                )
              )
      ),
      
      # Comparisons Tab
      tabItem(tabName = "comparisons",
              h2("Portfolio Performance Comparisons"),
              tabsetPanel(
                tabPanel("Sharpe Performance",
                         fluidRow(
                           box(title = "Out-of-Sample Sharpe Performance", status = "warning", solidHeader = TRUE, width = 6,
                               DTOutput("sharpe_performance_table"),
                               p("This table compares the out-of-sample Sharpe Ratios of different portfolio strategies.")
                           ),
                           box(title = "Monte Carlo vs. 1/N Sharpe Comparison", status = "warning", solidHeader = TRUE, width = 6,
                               verbatimTextOutput("sharpe_comparison_text"),
                               p("This shows the proportion of Monte Carlo simulated MV portfolios that outperform the 1/N portfolio.")
                           )
                         )
                ),
                tabPanel("Target Risk Portfolio Summary",
                         fluidRow(
                           box(title = "Target Risk Portfolio Summary", status = "warning", solidHeader = TRUE, width = 12,
                               DTOutput("target_risk_summary"),
                               p("Summary of the return and standard deviation for the target risk tolerance portfolio.")
                           )
                         )
                ),
                tabPanel("Tangency Portfolio Summary",
                         fluidRow(
                           box(title = "Tangency Portfolio Summary", status = "warning", solidHeader = TRUE, width = 12,
                               DTOutput("tangency_summary"),
                               p("Summary of the annualized return and standard deviation of the Tangency Portfolio.")
                           )
                         )
                ),
                tabPanel("MV Frontiers Plot",
                         fluidRow(
                           box(title = "MV Frontiers: With and Without Risk-Free Asset", status = "warning", solidHeader = TRUE, width = 12,
                               plotlyOutput("mv_frontiers_plot"),
                               p("This plot illustrates efficient frontiers under two scenarios: with and without the risk-free asset.")
                           )
                         )
                )
              )
      )
    )
  )
)
