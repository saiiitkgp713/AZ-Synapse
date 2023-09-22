--CREATE DATABASE appdb

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Qwerty@123456'

CREATE DATABASE SCOPED CREDENTIAL SasToken
with IDENTITY = 'SHARED ACCESS SIGNATURE',
SECRET = 'sv=2022-11-02&ss=bf&srt=sco&sp=rwy&se=2023-09-17T20:07:57Z&st=2023-09-17T12:07:57Z&spr=https&sig=0XmloKMlWKRZN8oNEenLNyL0lDCF%2BybRqSJuiUsQUSU%3D'
--- shared access signature for storage accounts expires, you may need new one

CREATE EXTERNAL DATA SOURCE LOG_DAT
WITH (
    LOCATION = 'https://adeses2rg1strg1.blob.core.windows.net/csv',
    CREDENTIAL = SasToken
)

CREATE EXTERNAL FILE FORMAT csvFormat
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
    [Time] [datetime] NULL,
    [Subscription] [varchar](200) NULL,
    [Event initiated by] [varchar](1000) NULL,
    [Resource type] [varchar](1000) NULL,
    [Resource group] [varchar](1000) NULL, 
    [Resource] [varchar](2000) NULL
)
WITH
(
    LOCATION = '/Log.csv',             -- Specify the path to the CSV file in ADLS
    DATA_SOURCE = LOG_DAT,      -- Specify your external data source name
    FILE_FORMAT = csvFormat           -- Specify your external file format name
)


