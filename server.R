server <- function(input, output, session) {
  
  # Overview Tab
  output$stock_prices_plot <- renderPlotly({
    df <- adjusted_prices %>%
      fortify.zoo() %>%
      pivot_longer(-Index, names_to = "Stock", values_to = "Price")
    
    plot_ly(df, x = ~Index, y = ~Price, color = ~Stock, type = 'scatter', mode = 'lines') %>%
      layout(title = "Adjusted Closing Prices",
             xaxis = list(title = "Date"),
             yaxis = list(title = "Price"))
  })
  
  output$stock_returns_plot <- renderPlotly({
    df <- daily_returns %>%
      fortify.zoo() %>%
      pivot_longer(-Index, names_to = "Stock", values_to = "Return")
    
    plot_ly(df, x = ~Index, y = ~Return, color = ~Stock, type = 'scatter', mode = 'lines') %>%
      layout(title = "Daily Returns",
             xaxis = list(title = "Date"),
             yaxis = list(title = "Return"))
  })
  
  output$adjusted_data_table <- renderDT({
    datatable(round(as.data.frame(adjusted_prices), 2), options = list(pageLength = 10))
  })
  
  output$returns_data_table <- renderDT({
    datatable(round(as.data.frame(daily_returns), 2), options = list(pageLength = 10))
  })
  
  # Portfolio Analysis Tab
  output$mean_sd_table <- renderDT({
    df <- data.frame(Asset = stock_symbols,
                     MeanReturn = as.numeric(mean_returns),
                     StdDev = as.numeric(sd_returns))
    datatable(df) %>%
      formatRound(columns = c("MeanReturn", "StdDev"), digits = 2)
  })
  
  output$covariance_table <- renderDT({
    datatable(round(cov_matrix, 2))
  })
  
  output$efficient_frontier_plot <- renderPlotly({
    plot_ly() %>%
      add_trace(x = efficient_frontier$Risk, y = efficient_frontier$Return,
                type = 'scatter', mode = 'markers', name = 'Portfolios',
                marker = list(color = 'blue')) %>%
      add_trace(x = efficient_frontier$Risk[gmv_index],
                y = efficient_frontier$Return[gmv_index],
                type = 'scatter', mode = 'markers', name = 'GMV',
                marker = list(color = 'red', size = 10, symbol = 'triangle-up')) %>%
      add_trace(x = efficient_frontier$Risk[tangency_index],
                y = efficient_frontier$Return[tangency_index],
                type = 'scatter', mode = 'markers', name = 'Tangency',
                marker = list(color = 'green', size = 10, symbol = 'square')) %>%
      layout(title = "Efficient Frontier",
             xaxis = list(title = "Risk (Std Dev)"),
             yaxis = list(title = "Return"))
  })
  
  output$optimal_weights_table <- renderDT({
    datatable(gmv_weights_df) %>%
      formatRound(columns = "Weight", digits = 2)
  })
  
  output$optimal_weights_chart <- renderPlotly({
    plot_ly(gmv_weights_df, x = ~Asset, y = ~Weight, type = 'bar',
            marker = list(color = 'skyblue')) %>%
      layout(title = "GMV Portfolio Weights",
             xaxis = list(title = "Asset", tickangle = -45),
             yaxis = list(title = "Weight"))
  })
  
  output$tangency_weights_table <- renderDT({
    datatable(tangency_weights_df) %>%
      formatRound(columns = "Weight", digits = 2)
  })
  
  output$tangency_weights_chart <- renderPlotly({
    plot_ly(tangency_weights_df, x = ~Asset, y = ~Weight, type = 'bar',
            marker = list(color = 'lightgreen')) %>%
      layout(title = "Tangency Portfolio Weights",
             xaxis = list(title = "Asset", tickangle = -45),
             yaxis = list(title = "Weight"))
  })
  
  # Risk Management Tab
  output$var_table <- renderDT({
    df <- data.frame(Asset = stock_symbols, VaR_95 = as.numeric(var_95))
    datatable(df) %>%
      formatRound(columns = "VaR_95", digits = 2)
  })
  
  output$sharpe_ratio_plot <- renderPlotly({
    plot_ly(sharpe_ratios_df, x = ~Asset, y = ~SharpeRatio, type = 'bar',
            marker = list(color = 'orange')) %>%
      layout(title = "Sharpe Ratios",
             xaxis = list(title = "Asset", tickangle = -45),
             yaxis = list(title = "Sharpe Ratio"))
  })
  
  output$correlation_plot <- renderPlot({
    corrplot::corrplot(cor_matrix, method = "color", type = "upper",
                       tl.col = "black", tl.srt = 45)
  })
  
  # Comparisons Tab
  output$sharpe_performance_table <- renderDT({
    df <- data.frame(
      Portfolio = c("Tangency", "Equal Weight"),
      SharpeRatio = c(
        round(efficient_frontier$Sharpe[tangency_index], 2),
        round(mean(sharpe_ratios), 2)
      )
    )
    datatable(df)
  })
  
  output$sharpe_comparison_text <- renderPrint({
    monte_carlo_sharpes <- efficient_frontier$Sharpe
    equal_weight_sharpe <- mean(sharpe_ratios)
    proportion_better <- mean(monte_carlo_sharpes > equal_weight_sharpe)
    cat(sprintf("Proportion of Monte Carlo portfolios outperforming Equal Weight: %.2f%%",
                proportion_better * 100))
  })
  
  output$target_risk_summary <- renderDT({
    target_return <- sum(gmv_weights * mean_returns)
    target_risk <- sqrt(t(gmv_weights) %*% cov_matrix %*% gmv_weights)
    df <- data.frame(Return = as.numeric(target_return), Risk = as.numeric(target_risk))
    datatable(df) %>%
      formatRound(columns = c("Return", "Risk"), digits = 2)
  })
  
  output$tangency_summary <- renderDT({
    tangency_return <- sum(tangency_weights * mean_returns)
    tangency_risk <- sqrt(t(tangency_weights) %*% cov_matrix %*% tangency_weights)
    df <- data.frame(Return = as.numeric(tangency_return), Risk = as.numeric(tangency_risk))
    datatable(df) %>%
      formatRound(columns = c("Return", "Risk"), digits = 2)
  })
  
  output$mv_frontiers_plot <- renderPlotly({
    plot_ly() %>%
      add_trace(x = efficient_frontier$Risk, y = efficient_frontier$Return,
                type = 'scatter', mode = 'markers', name = 'Portfolios',
                marker = list(color = 'blue')) %>%
      add_trace(x = sd_returns, y = mean_returns,
                type = 'scatter', mode = 'markers', name = 'Assets',
                marker = list(color = 'green', symbol = 'circle')) %>%
      add_trace(x = efficient_frontier$Risk[gmv_index],
                y = efficient_frontier$Return[gmv_index],
                type = 'scatter', mode = 'markers', name = 'GMV',
                marker = list(color = 'red', size = 10, symbol = 'triangle-up')) %>%
      add_trace(x = efficient_frontier$Risk[tangency_index],
                y = efficient_frontier$Return[tangency_index],
                type = 'scatter', mode = 'markers', name = 'Tangency',
                marker = list(color = 'green', size = 10, symbol = 'square')) %>%
      add_trace(x = c(0, efficient_frontier$Risk[tangency_index]),
                y = c(risk_free_rate, efficient_frontier$Return[tangency_index]),
                type = 'scatter', mode = 'lines', name = 'Capital Market Line',
                line = list(color = 'red', dash = 'solid', width = 2)) %>%
      layout(title = "Mean-Variance Frontiers",
             xaxis = list(title = "Risk (Std Dev)"),
             yaxis = list(title = "Return"))
  })
}
