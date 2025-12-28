INSERT INTO FUNCTION file('/var/lib/clickhouse/user_files/result.csv', 'CSVWithNames')
SELECT us_state, cat_id
FROM(
    SELECT
        us_state,
        cat_id,
        amount,
        ROW_NUMBER() OVER (PARTITION BY us_state ORDER BY amount DESC) AS rn
    FROM transactions
) t
WHERE rn = 1;