CREATE DATABASE SCOPED CREDENTIAL AZcredential
with IDENTITY = 'adeses2rg1strg1',
SECRET = 'TdCzG5WN6IUhp6nS4Ju++fURflvS3s8CS5vLFH6ATViXp7wHmhIOEKOJSiDjlqeff2WN+NNVHEZ8+AStpGSSXg=='
--- for identity we used storage name and for secret we used ACCESS KEYS of the storage account 

CREATE EXTERNAL DATA SOURCE log_csvdATA
WITH
(
    LOCATION =  'abfss://csv@adeses2rg1strg1.dfs.core.windows.net',
            --- abfss://mycontainer@mystorageaccount.dfs.core.windows.net/mydata
    CREDENTIAL = AZcredential,
    TYPE = HADOOP
)

CREATE EXTERNAL FILE FORMAT csv_format
WITH
(
    FORMAT_TYPE = DELIMITEDTEXT,
    FORMAT_OPTIONS (
        FIELD_TERMINATOR = ',',
        FIRST_ROW = 2,  -- Skip the first row if it contains headers
        USE_TYPE_DEFAULT = TRUE
    )
)


-- Create an external table for a CSV file in ADLS
CREATE EXTERNAL TABLE logTable
(
    [Correlation id] [varchar](200) NULL,
    [Operation name] [varchar](200) NULL,
    [Status] [varchar](100) NULL,
    [Event category] [varchar](100) NULL,
    [Level] [varchar](100) NULL,
    [Time] [varchar](100) NULL,--------- [datetime] NULL,
    ---- there is change hear, we used varchar rather the date beacuse of hadoop extension for reading the csv file
    [Subscription] [varchar](200) NULL,
    [Event initiated by] [varchar](1000) NULL,
    [Resource type] [varchar](1000) NULL,
    [Resource group] [varchar](1000) NULL, 
    [Resource] [varchar](2000) NULL
)
WITH
(
    LOCATION = '/Log.csv',             -- Specify the path to the CSV file in ADLS
    DATA_SOURCE = log_csvdATA,      -- Specify your external data source name
    FILE_FORMAT = csv_format           -- Specify your external file format name
)
