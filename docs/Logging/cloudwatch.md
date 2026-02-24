# CloudWatch Insights

```sql
fields @timestamp, @message, @logStream, @log
| filter @message not like /healthcheck/ 
| sort @timestamp desc
| limit 100
```

```sql
fields @timestamp, @message, @logStream, @log
| filter @message not like /healthcheck/ 
| filter @message like / 2[0-9]{2} /
| sort @timestamp desc
| limit 100
```

- 한 눈에 지표를 볼 수 있도록 Dashboard 구성
- EC2 지표 : CPUUtilization
- ALB 지표 : RequestCount, TargetResponseTime, HTTPCode_Target_5XX_Count
- RDS 지표 : CPUUtilization
- DynamoDB 지표 : ConsumedReadCapacityUnits, ConsumedWriteCapacityUnits
- 로그 테이블에서 “/healthcheck” 경로 필터링

- `CREATE INDEX user_email ON user (email);`

- `^[^@]+@[^@]+\.[^@]+$`