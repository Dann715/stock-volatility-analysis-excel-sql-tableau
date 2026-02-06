CREATE DATABASE mv_analysis;
USE mv_analysis;

CREATE TABLE mv_stock (
    date DATE NOT NULL,
    symbol ENUM('M', 'V') NOT NULL,  -- 'M' for MasterCard, 'V' for Visa
    open_price DECIMAL(10,2),
    high_price DECIMAL(10,2),
    low_price DECIMAL(10,2),
    close_price DECIMAL(10,2),
    adj_close_price DECIMAL(10,2),
    volume BIGINT,
    PRIMARY KEY (date, symbol)  -- Ensures no duplicate date-symbol entries
);

CREATE TABLE temp_stock (
    date DATE,
    open_m DECIMAL(10,2),
    high_m DECIMAL(10,2),
    low_m DECIMAL(10,2),
    close_m DECIMAL(10,2),
    adj_close_m DECIMAL(10,2),
    volume_m BIGINT,
    open_v DECIMAL(10,2),
    high_v DECIMAL(10,2),
    low_v DECIMAL(10,2),
    close_v DECIMAL(10,2),
    adj_close_v DECIMAL(10,2),
    volume_v BIGINT
);

INSERT INTO mv_stock (date, symbol, open_price, high_price, low_price, close_price, adj_close_price, volume)
SELECT date, 'M', open_m, high_m, low_m, close_m, adj_close_m, volume_m FROM temp_stock
UNION ALL
SELECT date, 'V', open_v, high_v, low_v, close_v, adj_close_v, volume_v FROM temp_stock;

select *
FROM mv_stock;


-- Analysis

#1 Daily Percentage Change (Stock Volatility) 
SELECT 
date, 
symbol, 
(close_price - LAG(close_price) OVER (PARTITION BY symbol ORDER BY date)) / LAG(close_price) OVER (PARTITION BY symbol ORDER BY date) * 100 AS daily_return
FROM mv_stock;
-- Measures day to day price fluctuations 

#2 Monthly average volatility 
WITH daily_returns AS (
    SELECT 
        date,
        symbol,
        (close_price - LAG(close_price) OVER (PARTITION BY symbol ORDER BY date)) / LAG(close_price) OVER (PARTITION BY symbol ORDER BY date) * 100 AS daily_return
    FROM mv_stock
)
SELECT 
    symbol,
    YEAR(date) AS year,
    MONTH(date) AS month,
    STDDEV(daily_return) AS monthly_volatility
FROM daily_returns
WHERE daily_return IS NOT NULL  -- Exclude first row per stock (which has NULL daily return)
GROUP BY symbol, YEAR(date), MONTH(date)
ORDER BY symbol, year, month;

#3 Highest & Lowest Stock prices
SELECT 
    symbol,
    MAX(high_price) AS highest_price,
    MIN(low_price) AS lowest_price
FROM mv_stock
GROUP BY symbol;

#4 50 Day & 200 Day Moving Averages
SELECT 
    date,
    symbol,
    AVG(close_price) OVER (PARTITION BY symbol ORDER BY date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) AS moving_avg_50,
    AVG(close_price) OVER (PARTITION BY symbol ORDER BY date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW) AS moving_avg_200
FROM mv_stock;

#5 Trading volume trends overtime
SELECT 
    symbol,
    YEAR(date) AS year,
    MONTH(date) AS month,
    AVG(volume) AS avg_monthly_volume
FROM mv_stock
GROUP BY symbol, YEAR(date), MONTH(date)
ORDER BY symbol, year, month;


#6 Best and Worst Performing Months for Each Stock
CREATE TEMPORARY TABLE daily_changes AS
SELECT 
    date, 
    symbol, 
    close_price,
    LAG(close_price) OVER (PARTITION BY symbol ORDER BY date) AS prev_close_price
FROM mv_stock;

CREATE TEMPORARY TABLE price_movement AS
SELECT 
    date, 
    symbol, 
    close_price,
    prev_close_price,
    CASE 
        WHEN close_price > prev_close_price THEN 'gain'
        WHEN close_price < prev_close_price THEN 'loss'
        ELSE 'no_change'
    END AS change_type
FROM daily_changes;

SET @prev_symbol = NULL;
SET @prev_change = NULL;
SET @streak_id = 0;

CREATE TEMPORARY TABLE streaks AS
SELECT 
    date, 
    symbol, 
    change_type,
    @streak_id := IF(@prev_symbol = symbol AND @prev_change = change_type, @streak_id, @streak_id + 1) AS streak_id,
    @prev_symbol := symbol,
    @prev_change := change_type
FROM price_movement
ORDER BY symbol, date;

SELECT 
    symbol, 
    change_type, 
    COUNT(*) AS streak_length,
    MIN(date) AS start_date, 
    MAX(date) AS end_date
FROM streaks
GROUP BY symbol, change_type, streak_id
ORDER BY streak_length DESC
LIMIT 5;


