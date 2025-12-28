### Requirements
- Docker 20.10+
- Docker Compose 2.0+

### Getting started
```bash
git clone https://github.com/kre1ses/clickhouse_usage_example.git
cd clickhouse_usage_example
```

0. Place your CSV file or dowload train.csv from here (https://www.kaggle.com/competitions/teta-ml-1-2025/data?select=train.csv) to "./data/" folder

1. Install requirements:
```bash
pip install -r requirements.txt
```

2. Run docker container:
```bash
docker-compose up -d
```

3. Start service:
```bash
.\run_all.ps1
```

4. Result will be locally saved in result.csv