# Data Wharehouse
Tables:
## plenty_orders
[Flow](https://apps.synesty.com/studio/jobController?action=viewEventLog&jobid=32f91971-044a-11ed-9def-901b0ea49fee)
Flow runns every 24h and appends to the existing file on the ftp server
```sql
CREATE TABLE `plenty_export` (
  `Tenant` varchar(50) NOT NULL,
  `OrderID` bigint NOT NULL,
  `PackageNumber` bigint NOT NULL,
  `PaidAt` datetime date_format='YYYY-MM-DD"T"hh:mm:ss"Z"' NOT NULL,
  `CreatedAt` datetime date_format='YYYY-MM-DD"T"hh:mm:ss"Z"' NOT NULL,
  `UpdatedAt` datetime date_format='YYYY-MM-DD"T"hh:mm:ss"Z"' NOT NULL,
  `CompletedAt` datetime date_format='YYYY-MM-DD"T"hh:mm:ss"Z"' NOT NULL,
  `Country` varchar(50) NOT NULL,
  `IssuedAt` datetime date_format='YYYY-MM-DD"T"hh:mm:ss"Z"' NOT NULL
) ENGINE='CONNECT' `header`='1' `TABLE_TYPE`=CSV `QUOTED`='1' `FILE_NAME`='../upload/plenty_export.csv';
```

## gls_export
[Flow](https://apps.synesty.com/studio/jobController?action=viewEventLog&jobid=cd2a45c0-0660-11ed-9def-901b0ea49fee)
Flow runns every 24h and appends to the existing file on the ftp server
```sql
CREATE TABLE `gls_export` (
  `PackageNumber` bigint NOT NULL,
  `PickedUpAt` datetime date_format='YYYY-MM-DD"T"hh:mm:ss' NOT NULL,
  `DeliveredAt` datetime date_format='YYYY-MM-DD"T"hh:mm:ss"Z"' NOT NULL,
  `AbfrageDauer` varchar(50) NOT NULL,
  `Abfrageantwort` varchar(50) NOT NULL,
  `Ziel Land` varchar(50) NOT NULL
) ENGINE='CONNECT' `header`='1' `TABLE_TYPE`=CSV `QUOTED`='0' `FILE_NAME`='../upload/gls_data.csv';
```

# Idk
```sql
SELECT * FROM information_schema.ENGINES
WHERE ENGINE = "CONNECT" 
```
# Connect Storage Engine
https://mariadb.com/kb/en/connect/
## Inward / Outward
```sql
CREATE TABLE file_table (
    a INT,
    b INT
)
    ENGINE = CONNECT,
    TABLE_TYPE = CSV,
    FILE_NAME = "data.csv"
;
```

 - A file-based table can be inward or onward
 - IF `FILE_NAME` is specified the thable is outward
 - Outward tables are assumed to be "holy", (Read-Only)

 ## Create inward table
```sql
CREATE TBALE csv_data ( ... ) ENGINE = CONNECT, TABLE_TYPE = CSV;
```

- The CSV file will be located in the databse directory
- In this case, csv_data.csv
- To know the exact name:
    - SHOW WARNINGS;
    - Regexp to get the filename : \s(\w+)$ 

## Import + Modify + Export (ETL)
- Receive data in a understood format
- Make some changes
    ```sql
        SELECT column_list FROM table;
        SELECT a, AVG(b) FROM table GROUP BY a;
    ```
- Export the data!

## Exporting Tables 
```sql
ALTER TABLE numbers
    ENGINE = CONNECT,
    TABLE_TYPE = CSV,
    SEP_CHAR = '\t'
;
```
- Most efficient way of exporting tables that are not needed. 

## More features:
- File parsing, everything that is "computer generated" can get parsed with own parsing templates. Like Logs, etc..
- File formats (JSON, XML, HTML tables, ini, fixed-length,..)
- compressed files
- connection via MySQL format, ODBC, JDBC, MongoDB
- Querying remote REST API's
- more....

Hints:
 - build proper indexes where possible
 - increase conect_work_size if files are big



 ```sql
DROP TABLE IF EXISTS `incoming_gls`;
CREATE TABLE `incoming_gls` (
  `paketnr` varchar(100) NOT NULL,
  `glsuebername` varchar(100) NOT NULL,
  `zustelldatum` varchar(100) NOT NULL,
  `abfragedauer` varchar(100) NOT NULL,
  `abfrageantwort` varchar(100) NOT NULL,
  `zielland` varchar(100) NOT NULL
) ENGINE=CONNECT DEFAULT CHARSET=utf8mb4 `TABLE_TYPE`=CSV `FILE_NAME`='../upload/gls_export.csv';

DROP TABLE IF EXISTS `gls`;
CREATE TABLE `gls` (
  `paketnr` varchar(100) NOT NULL,
  `glsuebername` varchar(100) NOT NULL,
  `zustelldatum` varchar(100) NOT NULL,
  `abfragedauer` varchar(100) NOT NULL,
  `abfrageantwort` varchar(100) NOT NULL,
  `zielland` varchar(100) NOT NULL
) ;

INSERT INTO `gls`
SELECT * FROM test.incoming_gls
```