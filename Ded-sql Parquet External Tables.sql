CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Qwerty@123456'

CREATE DATABASE SCOPED CREDENTIAL SasToken
with IDENTITY = 'SHARED ACCESS SIGNATURE',
SECRET = 'sv=2022-11-02&ss=bfqt&srt=sco&sp=rwcpy&se=2023-09-30T23:00:12Z&st=2023-09-18T15:00:12Z&spr=https&sig=dww5k24ETkYefvKswwi9xIh0vTvNgDnP6IdN%2FM3V6Aw%3D'
--- shared access signature for storage accounts expires, you may need new one

CREATE EXTERNAL DATA SOURCE LOG_parqDAT
WITH (
    LOCATION = 'https://adeses2rg1strg1.blob.core.windows.net/parquet',
    CREDENTIAL = SasToken
)

CREATE EXTERNAL FILE FORMAT parquetFormat
WITH
(  
    FORMAT_TYPE = PARQUET,
    DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'
)


-- Create an external table for a CSV file in ADLS
CREATE EXTERNAL TABLE logParqTable
(
    [Correlation id] [varchar](200) NULL,
    [Operation name] [varchar](200) NULL,
    [Status] [varchar](100) NULL,
    [Event category] [varchar](100) NULL,
    [Level] [varchar](100) NULL,
    [Time] [datetime] NULL,
    [Subscription] [varchar](200) NULL,
    [Event initiated by] [varchar](1000) NULL,
    [Resource type] [varchar](1000) NULL,
    [Resource group] [varchar](1000) NULL, 
    [Resource] [varchar](2000) NULL
)
WITH
(
    LOCATION = '/log.parquet',             -- Specify the path to the CSV file in ADLS
    DATA_SOURCE = LOG_parqDAT,      -- Specify your external data source name
    FILE_FORMAT = parquetFormat           -- Specify your external file format name
)


