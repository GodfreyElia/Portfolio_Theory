# 📈 Stock Portfolio Optimization Dashboard

<br clear="both">

<div align="center">
  <img height="400" width="100%" src="https://github.com/GodfreyElia/Portfolio_Theory/blob/main/Efficient%20frontier.png"  />
</div>

##  Description: 

I have built this dashboard in R to provide an interactive way of analysing popular stocks using the principles of portfolio theory. The dashoboard is hosted by Shinyapps and uses live stock market data of 15 select stocks from yahoo finance. In using the dashboard, you will be able to explore latest stock prices, daily returns, key portfolio metrics, and portfolio optimization strategies. Furthermore, you will also be enabled to visualize stock performance, compute optimal asset allocations, and evaluate risk metrics such as Value at Risk (VaR) and Sharpe Ratios.

## 🔧 Features.

What to expect in the dashboard:

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

## 🧠 Under the Hood

- **Data Source**: Stock data retrieved using `quantmod` or equivalent methods
- **Optimization**: Mean-Variance Optimization using covariance matrices and risk-return trade-offs
- **Risk Metrics**: Value at Risk (95%), Sharpe Ratios

## 🚀 Getting Started

Please find the dashboard (here)[https://godfreyelia.shinyapps.io/Portfolio_Theory/]

I hope you have fun and learn something. Please, if you have any feedback for me, kindly send an email using the link embedded in the dashboard.
