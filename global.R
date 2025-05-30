# Load required libraries
library(shiny)
library(shinydashboard)
library(quantmod)
library(tidyverse)
library(plotly)
library(DT)
library(PerformanceAnalytics)
library(quadprog)

# Define stock symbols and risk-free rate
stock_symbols <- c("AAPL", "MSFT", "GOOGL", "AMZN", "META", "TSLA", "BRK-B", "JPM", "V", "JNJ", "NVDA", "PG", "UNH", "BAC", "MA")
risk_free_rate <- 0.015  # 1.5% annual risk-free rate

# Define date range for data retrieval
end_date <- Sys.Date()
start_date <- end_date - 365 * 2  # Last 2 years

# Retrieve adjusted closing prices
get_stock_data <- function(symbols, start, end) {
  prices_list <- lapply(symbols, function(sym) {
    tryCatch({
      Ad(getSymbols(sym, src = "yahoo", from = start, to = end, auto.assign = FALSE))
    }, error = function(e) {
      warning(paste("Error fetching data for", sym))
      NULL
    })
  })
  prices_xts <- do.call(merge, prices_list)
  colnames(prices_xts) <- symbols
  return(prices_xts)
}

adjusted_prices <- get_stock_data(stock_symbols, start_date, end_date)

# Calculate daily returns
daily_returns <- na.omit(Return.calculate(adjusted_prices, method = "log"))

# Annualize mean returns and standard deviations
mean_returns <- colMeans(daily_returns) * 252
sd_returns <- apply(daily_returns, 2, sd) * sqrt(252)

# Compute covariance and correlation matrices
cov_matrix <- cov(daily_returns) * 252
cor_matrix <- cor(daily_returns)

# Function to compute efficient frontier
compute_efficient_frontier <- function(returns, cov_matrix, n_portfolios = 10000) {
  n_assets <- ncol(returns)
  results <- matrix(nrow = n_portfolios, ncol = 3)
  weights_list <- list()
  
  for (i in 1:n_portfolios) {
    weights <- runif(n_assets)
    weights <- weights / sum(weights)
    weights_list[[i]] <- weights
    port_return <- sum(weights * mean_returns)
    port_sd <- sqrt(t(weights) %*% cov_matrix %*% weights)
    sharpe_ratio <- (port_return - risk_free_rate) / port_sd
    results[i, ] <- c(port_return, port_sd, sharpe_ratio)
  }
  
  results_df <- as.data.frame(results)
  colnames(results_df) <- c("Return", "Risk", "Sharpe")
  results_df$Weights <- weights_list
  return(results_df)
}

# Generate efficient frontier
efficient_frontier <- compute_efficient_frontier(daily_returns, cov_matrix)

# Identify Global Minimum Variance (GMV) and Tangency Portfolios
gmv_index <- which.min(efficient_frontier$Risk)
tangency_index <- which.max(efficient_frontier$Sharpe)

gmv_weights <- efficient_frontier$Weights[[gmv_index]]
tangency_weights <- efficient_frontier$Weights[[tangency_index]]

# Create weight tables
gmv_weights_df <- data.frame(Asset = stock_symbols, Weight = round(gmv_weights, 4))
tangency_weights_df <- data.frame(Asset = stock_symbols, Weight = round(tangency_weights, 4))

# Compute Value at Risk (VaR) at 95% confidence level
compute_var <- function(returns, confidence = 0.95) {
  apply(returns, 2, function(x) {
    quantile(x, probs = 1 - confidence)
  })
}

var_95 <- compute_var(daily_returns)

# Compute Sharpe Ratios for individual stocks
sharpe_ratios <- (mean_returns - risk_free_rate) / sd_returns
sharpe_ratios_df <- data.frame(Asset = stock_symbols, SharpeRatio = round(sharpe_ratios, 4))
