# Visa vs Mastercard Stock Volatility Analysis
📌 Project Overview

This project analyzes and compares the stock volatility of Visa (V) and Mastercard (M) using historical market data. The goal is to evaluate risk, price stability, and trend behavior over time using an end-to-end analytics workflow that mirrors real-world data analyst tasks.

The project follows a complete pipeline:
Excel (data validation & cleaning) → MySQL (SQL analysis) → Tableau (data visualization & storytelling)

🎯 Objectives

- Clean and validate historical stock price data
- Calculate daily returns and measure volatility over time
- Compare risk patterns between Visa and Mastercard
- Identify major market volatility periods
- Visualize trends and insights using Tableau dashboards

🛠 Tools & Technologies

- Excel - Data validation, cleaning, and quality checks
- MySQL - LData storage, transformation, and analysis using SQL
- SQL - Window functions, aggregations, trend and volatility calculations
- Tableau - Interactive dashboards and visual storytelling

📂 Data Description

The dataset contains historical daily stock data for:
- Visa (V)
- Mastercard (M)
Key fields include:
- Date
- Open, High, Low, Close, Adjusted Close prices
- Trading Volume

Initial data quality checks were performed in Excel:
- Removed duplicates and blanks
- Validated data types
- Checked numeric ranges for price and volume fields
- The cleaned data was then loaded into MySQL for analysis.

🧠 Analysis Performed
1. Daily Percentage Change (Returns)
Calculated day-over-day returns using SQL window functions to measure short-term price movement.

2. Monthly Volatility
Computed monthly volatility as the standard deviation of daily returns to quantify risk over time.

3. Highest & Lowest Prices
Identified peak and trough prices for each stock across the dataset.

4. 50-Day & 200-Day Moving Averages
Calculated short-term and long-term moving averages to analyze trend direction and momentum.

5. Trading Volume Trends
Aggregated average monthly trading volume to observe changes in market activity over time.

6. Bull and Bear Runs
Detected consecutive gain and loss streaks to identify extended bullish and bearish periods.

📊 Key Visualization: Monthly Average Volatility

This dashboard compares the monthly average volatility of Visa and Mastercard over time.
<img width="500" height="500" alt="image" src="https://github.com/user-attachments/assets/70d1339b-2b2e-4bd8-b2bf-fe06fa2547cc" />

✨ Key Insights

- Mastercard generally exhibits higher volatility than Visa across most years, indicating greater short-term price fluctuations and risk.
- Both stocks experienced significant volatility spikes around suggesting broader market instability during that period.
- Volatility levels declined steadily after the spike, indicating a return to more stable market conditions.
- The lowest volatility periods appear around 2017 and again in recent years, suggesting relatively stable price movement.
- While both stocks follow similar long-term patterns, Mastercard consistently shows larger volatility swings.

📈 Business Value

This analysis helps:
- Compare risk profiles between two major financial companies
- Identify periods of market instability
- Support investment, risk, and strategy decisions with data
- Demonstrate an end-to-end analytics workflow used in real business environments

