# 📈 Stock Portfolio Optimization Dashboard

An interactive R Shiny `shinydashboard` web application for analyzing and optimizing stock portfolios using historical data. The dashboard enables users to visualize stock performance, compute optimal asset allocations, and evaluate risk metrics such as Value at Risk (VaR) and Sharpe Ratios.

## 🔧 Features

### 🗂 Overview Tab
- Adjusted Closing Prices (Interactive Plot)
- Daily Returns (Interactive Plot)
- View raw adjusted price and return data (DataTables)

### 📊 Data Visualization Tab
- Mean vs Standard Deviation of Asset Returns
- Covariance Matrix (DataTable)
- Correlation Matrix (Heatmap)

### 💼 Portfolio Analysis Tab
- Efficient Frontier (Static ggplot)
- GMV (Global Minimum Variance) Portfolio Weights and Chart
- Tangency Portfolio Weights and Chart
- Optimal Portfolio Tables

### ⚠️ Risk Management Tab
- Value at Risk (VaR) for individual assets
- Sharpe Ratios (Bar Chart)
- Correlation Matrix (Static Heatmap)

### ⚖️ Comparisons Tab
- Tangency vs Equal Weight Portfolio Performance
- Capital Market Line vs Efficient Frontier (Static ggplot)
- Summary stats for GMV and Tangency Portfolios

### 🔮 Prediction Tab
- Select a stock and apply different machine learning models to forecast next-day return
- Supported methods: Linear Regression, SVM, Random Forest, Bagging, Boosting

## 🧠 Under the Hood

- **Data Source**: Stock data retrieved using `quantmod` or equivalent methods
- **Optimization**: Mean-Variance Optimization using covariance matrices and risk-return trade-offs
- **Risk Metrics**: Value at Risk (95%), Sharpe Ratios
- **Forecasting Models**: Based on `caret` or `mlr` frameworks with customizable input

## 🚀 Getting Started

### Prerequisites

Make sure you have the following R packages installed:

```r
install.packages(c(
  "shiny", "shinydashboard", "quantmod", "PerformanceAnalytics",
  "PortfolioAnalytics", "tseries", "plotly", "ggplot2", "DT",
  "caret", "randomForest", "e1071", "gbm", "corrplot", "dplyr", "tidyr", "zoo"
))
