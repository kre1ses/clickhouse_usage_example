DROP TABLE IF EXISTS transactions_mv;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS transactions_queue;

CREATE TABLE transactions_queue (
    us_state String,
    cat_id String,
    amount Float64
)
ENGINE = Kafka
SETTINGS
    kafka_broker_list = 'kafka:29092',
    kafka_topic_list = 'transactions',
    kafka_group_name = 'transactions_group',
    kafka_format = 'JSONEachRow',
    kafka_num_consumers = 1;

CREATE TABLE transactions (
    us_state LowCardinality(String),
    cat_id LowCardinality(String),
    amount Float64 CODEC(ZSTD(3))
)
ENGINE = MergeTree
PARTITION BY us_state
ORDER BY (us_state, cat_id);

CREATE MATERIALIZED VIEW transactions_mv
TO transactions
AS
SELECT
    us_state,
    cat_id,
    amount
FROM transactions_queue;
