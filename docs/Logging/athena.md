# Athena(Access logs) - Logging

## ALB Access Log

`Permission`
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::600734575887:root"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::apdev-log-s3-abcd/alb/*"
    }
  ]
}
```

`Creating Table`
```sql
CREATE EXTERNAL TABLE IF NOT EXISTS product (
            type string,
            time string,
            elb string,
            client_ip string,
            client_port int,
            target_ip string,
            target_port int,
            request_processing_time double,
            target_processing_time double,
            response_processing_time double,
            elb_status_code int,
            target_status_code string,
            received_bytes bigint,
            sent_bytes bigint,
            request_verb string,
            request_url string,
            request_proto string,
            user_agent string,
            ssl_cipher string,
            ssl_protocol string,
            target_group_arn string,
            trace_id string,
            domain_name string,
            chosen_cert_arn string,
            matched_rule_priority string,
            request_creation_time string,
            actions_executed string,
            redirect_url string,
            lambda_error_reason string,
            target_port_list string,
            target_status_code_list string,
            classification string,
            classification_reason string,
            conn_trace_id string
            )
            PARTITIONED BY
            (
             day STRING
            )
            ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
            WITH SERDEPROPERTIES (
            'serialization.format' = '1',
            'input.regex' = 
        '([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*):([0-9]*) ([^ ]*)[:-]([0-9]*) ([-.0-9]*) ([-.0-9]*) ([-.0-9]*) (|[-0-9]*) (-|[-0-9]*) ([-0-9]*) ([-0-9]*) \"([^ ]*) (.*) (- |[^ ]*)\" \"([^\"]*)\" ([A-Z0-9-_]+) ([A-Za-z0-9.-]*) ([^ ]*) \"([^\"]*)\" \"([^\"]*)\" \"([^\"]*)\" ([-.0-9]*) ([^ ]*) \"([^\"]*)\" \"([^\"]*)\" \"([^ ]*)\" \"([^\\s]+?)\" \"([^\\s]+)\" \"([^ ]*)\" \"([^ ]*)\" ?([^ ]*)?'
            )
            LOCATION 's3://apdev-log-s3-abcd/alb/product/AWSLogs/000000000000/elasticloadbalancing/ap-northeast-2/'
            TBLPROPERTIES
            (
             "projection.enabled" = "true",
             "projection.day.type" = "date",
             "projection.day.range" = "2022/01/01,NOW",
             "projection.day.format" = "yyyy/MM/dd",
             "projection.day.interval" = "1",
             "projection.day.interval.unit" = "DAYS",
             "storage.location.template" = "s3://apdev-log-s3-abcd/alb/product/AWSLogs/000000000000/elasticloadbalancing/ap-northeast-2/${day}"
            )
```

## CloutFront Logs (Legacy)
```sql
CREATE EXTERNAL TABLE IF NOT EXISTS cloudfront_standard_logs (
  `date` DATE,
  time STRING,
  x_edge_location STRING,
  sc_bytes BIGINT,
  c_ip STRING,
  cs_method STRING,
  cs_host STRING,
  cs_uri_stem STRING,
  sc_status INT,
  cs_referrer STRING,
  cs_user_agent STRING,
  cs_uri_query STRING,
  cs_cookie STRING,
  x_edge_result_type STRING,
  x_edge_request_id STRING,
  x_host_header STRING,
  cs_protocol STRING,
  cs_bytes BIGINT,
  time_taken FLOAT,
  x_forwarded_for STRING,
  ssl_protocol STRING,
  ssl_cipher STRING,
  x_edge_response_result_type STRING,
  cs_protocol_version STRING,
  fle_status STRING,
  fle_encrypted_fields INT,
  c_port INT,
  time_to_first_byte FLOAT,
  x_edge_detailed_result_type STRING,
  sc_content_type STRING,
  sc_content_len BIGINT,
  sc_range_start BIGINT,
  sc_range_end BIGINT
)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t'
LOCATION 's3://apdev-log-s3/cloudfront/'
TBLPROPERTIES ( 'skip.header.line.count'='2' )
```

## WAF Logs
```sql
CREATE EXTERNAL TABLE `waf_logs`(
  `timestamp` bigint, 
  `formatversion` int, 
  `webaclid` string, 
  `terminatingruleid` string, 
  `terminatingruletype` string, 
  `action` string, 
  `terminatingrulematchdetails` array<struct<conditiontype:string,sensitivitylevel:string,location:string,matcheddata:array<string>>>, 
  `httpsourcename` string, 
  `httpsourceid` string, 
  `rulegrouplist` array<struct<rulegroupid:string,terminatingrule:struct<ruleid:string,action:string,rulematchdetails:array<struct<conditiontype:string,sensitivitylevel:string,location:string,matcheddata:array<string>>>>,nonterminatingmatchingrules:array<struct<ruleid:string,action:string,overriddenaction:string,rulematchdetails:array<struct<conditiontype:string,sensitivitylevel:string,location:string,matcheddata:array<string>>>,challengeresponse:struct<responsecode:string,solvetimestamp:string>,captcharesponse:struct<responsecode:string,solvetimestamp:string>>>,excludedrules:string>>, 
  `ratebasedrulelist` array<struct<ratebasedruleid:string,limitkey:string,maxrateallowed:int>>, 
  `nonterminatingmatchingrules` array<struct<ruleid:string,action:string,rulematchdetails:array<struct<conditiontype:string,sensitivitylevel:string,location:string,matcheddata:array<string>>>,challengeresponse:struct<responsecode:string,solvetimestamp:string>,captcharesponse:struct<responsecode:string,solvetimestamp:string>>>, 
  `requestheadersinserted` array<struct<name:string,value:string>>, 
  `responsecodesent` string, 
  `httprequest` struct<clientip:string,country:string,headers:array<struct<name:string,value:string>>,uri:string,args:string,httpversion:string,httpmethod:string,requestid:string,fragment:string,scheme:string,host:string>,
  `labels` array<struct<name:string>>, 
  `captcharesponse` struct<responsecode:string,solvetimestamp:string,failurereason:string>, 
  `challengeresponse` struct<responsecode:string,solvetimestamp:string,failurereason:string>, 
  `ja3fingerprint` string, 
  `ja4fingerprint` string, 
  `oversizefields` string, 
  `requestbodysize` int, 
  `requestbodysizeinspectedbywaf` int)
  PARTITIONED BY ( 
   `log_time` string)
ROW FORMAT SERDE 
  'org.openx.data.jsonserde.JsonSerDe' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://apdev-log-s3-xxxx/AWSLogs/000000000000/WAFLogs/cloudfront/CreatedByCloudFront-<>/'
TBLPROPERTIES (
 'projection.enabled'='true',
  'projection.log_time.format'='yyyy/MM/dd/HH/mm',
  'projection.log_time.interval'='1',
  'projection.log_time.interval.unit'='minutes',
  'projection.log_time.range'='2025/08/08/00/00,NOW',
  'projection.log_time.type'='date',
  'storage.location.template'='s3://apdev-log-s3/AWSLogs/000000000000/WAFLogs/cloudfront/CreatedByCloudFront-<>/${log_time}')
```