CREATE OR ALTER PROCEDURE gameDW.CreateTables
AS
/***************************************************************************************************
File: CreateTables.sql
----------------------------------------------------------------------------------------------------
Procedure:      gameDW.CreateTables
Create Date:    2021-03-01 (yyyy-mm-dd)
Author:         Surush Cyrus
Description:    Creates all needed gameDW tables  
Call by:        TBD, UI, Add hoc
Steps:          NA
Parameter(s):   None
Usage:          EXEC gameDW.CreateTables
****************************************************************************************************
SUMMARY OF CHANGES
Date(yyyy-mm-dd)    Author              Comments
------------------- ------------------- ------------------------------------------------------------
****************************************************************************************************/
SET NOCOUNT ON;

DECLARE @ErrorText VARCHAR(MAX),      
        @Message   VARCHAR(255),   
        @StartTime DATETIME,
        @SP        VARCHAR(50)

BEGIN TRY;   
SET @ErrorText = 'Unexpected ERROR in setting the variables!';  

SET @SP = OBJECT_NAME(@@PROCID)
SET @StartTime = GETDATE();    
SET @Message = 'Started SP ' + @SP + ' at ' + FORMAT(@StartTime , 'MM/dd/yyyy HH:mm:ss');  
RAISERROR (@Message, 0,1) WITH NOWAIT;

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed CREATE Table gameDW.DimTime.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'gameDW.DimTime') AND type in (N'U'))
BEGIN
    SET @Message = 'Table gameDW.DimTime already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN
    CREATE TABLE gameDW.DimTime
    (
        TimeKey int IDENTITY (1, 1) NOT NULL ,
        -- ActualDate datetime NOT NULL ,
        ActualDate DATE NOT NULL ,
        Year int NOT NULL ,
        Quarter int NOT NULL ,
        Month int NOT NULL ,
        Week int NOT NULL ,
        DayofYear int NOT NULL ,
        DayofMonth int NOT NULL ,
        DayofWeek int NOT NULL ,
        IsWeekend bit NOT NULL ,
        Comments varchar(20) NULL ,
        CalendarWeek int NOT NULL ,
        BusinessYearWeek int NOT NULL ,
        LeapYear tinyint NOT NULL,
        CONSTRAINT PK_DimTime_TimeKey PRIMARY KEY CLUSTERED (TimeKey)
    );
    SET @Message = 'Completed CREATE TABLE gameDW.DimTime.';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed CREATE Table gameDW.DimRetailer.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'gameDW.DimRetailer') AND type in (N'U'))
BEGIN
    SET @Message = 'Table gameDW.DimRetailer already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN
    CREATE TABLE gameDW.DimRetailer
    (
        RetailerID TINYINT NOT NULL,
        Name NVARCHAR(50) NOT NULL,
        CONSTRAINT PK_DimRetailer_RetailerID PRIMARY KEY CLUSTERED (RetailerID),
        CONSTRAINT UK_DimRetailer_Name UNIQUE (Name)
    );

    SET @Message = 'Completed CREATE TABLE gameDW.DimRetailer.';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed CREATE Table gameDW.DimGame.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'gameDW.DimGame') AND type in (N'U'))
BEGIN
    SET @Message = 'Table gameDW.DimGame already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN
    CREATE TABLE gameDW.DimGame
    (
        GameID TINYINT NOT NULL,
        Name NVARCHAR(50) NOT NULL,
        GameType NVARCHAR(50) NOT NULL,
        Partner NVARCHAR(50) NOT NULL,
        Note NVARCHAR(250) NOT NULL,
        CONSTRAINT PK_DimGame_GameID PRIMARY KEY CLUSTERED (GameID),
        CONSTRAINT UK_DimGame_Name UNIQUE (Name)
    );

    SET @Message = 'Completed CREATE TABLE gameDW.DimGame.';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed CREATE Table gameDW.FactSales.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'gameDW.FactSales') AND type in (N'U'))
BEGIN
    SET @Message = 'Table gameDW.FactSales already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN
    CREATE TABLE gameDW.FactSales
    (
        OrderID INT NOT NULL,
        GameID TINYINT NOT NULL,
        RetailerID TINYINT NOT NULL,
        TimeKey INT NOT NULL,
        Quantity INT NOT NULL,
        TotalAmount MONEY NOT NULL,
        CONSTRAINT PK_FactSales_OrderID PRIMARY KEY CLUSTERED (OrderID)
    );

    SET @Message = 'Completed CREATE TABLE gameDW.FactSales.';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
-------------------------------------------------------------------------------


SET @Message = 'Completed SP ' + @SP + '. Duration in minutes:  '   
   + CONVERT(VARCHAR(12), CONVERT(DECIMAL(6,2),datediff(mi, @StartTime, getdate())));   
RAISERROR(@Message, 0,1) WITH NOWAIT;

END TRY

BEGIN CATCH;
IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

SET @ErrorText = 'Error: '+CONVERT(VARCHAR,ISNULL(ERROR_NUMBER(),'NULL'))      
                  +', Severity = '+CONVERT(VARCHAR,ISNULL(ERROR_SEVERITY(),'NULL'))      
                  +', State = '+CONVERT(VARCHAR,ISNULL(ERROR_STATE(),'NULL'))      
                  +', Line = '+CONVERT(VARCHAR,ISNULL(ERROR_LINE(),'NULL'))      
                  +', Procedure = '+CONVERT(VARCHAR,ISNULL(ERROR_PROCEDURE(),'NULL'))      
                  +', Server Error Message = '+CONVERT(VARCHAR(100),ISNULL(ERROR_MESSAGE(),'NULL'))      
                  +', SP Defined Error Text = '+@ErrorText;

RAISERROR(@ErrorText,18,127) WITH NOWAIT;
END CATCH;      

