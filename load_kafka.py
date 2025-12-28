import os
import json
import pandas as pd
from kafka import KafkaProducer
from pathlib import Path

KAFKA_BROKER = os.getenv("KAFKA_BROKER", "localhost:9092")
TOPIC_NAME = os.getenv("KAFKA_TOPIC", "transactions")
CSV_PATH = os.getenv("CSV_PATH", "train.csv")

def main():
    path = Path('data/' + CSV_PATH)
    df = pd.read_csv(path)

    df = df[["us_state", "cat_id", "amount"]]

    producer = KafkaProducer(
        bootstrap_servers=KAFKA_BROKER,
        value_serializer=lambda v: json.dumps(v).encode("utf-8")
    )

    for _, row in df.iterrows():
        producer.send(TOPIC_NAME, value=row.to_dict())

    producer.flush()
    producer.close()

    print(f"Sent {len(df)} rows to Kafka topic `{TOPIC_NAME}`")

if __name__ == "__main__":
    main()
