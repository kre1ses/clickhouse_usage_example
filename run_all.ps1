$ClickHouseContainer = "clickhouse_hw-clickhouse-1"
$CSVPath = "data/train.csv"
$KafkaContainer = "clickhouse_hw-kafka-1"
$ResultFile = "result.csv"
$ExpectedRows = 786431

Write-Host "1. Creating Tables"
Get-Content .\clickhouse_ddl.sql | docker exec -i $ClickHouseContainer clickhouse-client --user click --password click --multiquery

Write-Host "2. Load CSV data в Kafka"
python load_kafka.py

Write-Host "3. Waiting for ClickHouse"
$CurrentCount = 0
while ($CurrentCount -lt $ExpectedRows) {
    Start-Sleep -Seconds 2
    $CountResult = docker exec -i $ClickHouseContainer clickhouse-client --user click --password click --query "SELECT count(*) FROM transactions;"
    $CurrentCount = [int]($CountResult -replace '\D', '')
    Write-Host "Progress: $CurrentCount / $ExpectedRows"
}

Write-Host "4. SQL Query Execution"
Get-Content .\query.sql | docker exec -i $ClickHouseContainer clickhouse-client --user click --password click --multiquery

Write-Host "5. Retrieving Result File"
docker cp "${ClickHouseContainer}:/var/lib/clickhouse/user_files/result.csv" ".\$ResultFile"
