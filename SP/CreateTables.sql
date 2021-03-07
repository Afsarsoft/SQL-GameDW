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
SET @ErrorText = 'Failed CREATE Table gameDW.Retailer.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'gameDW.Retailer') AND type in (N'U'))
BEGIN
    SET @Message = 'Table gameDW.Retailer already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN
    CREATE TABLE gameDW.Retailer
    (
        RetailerID TINYINT NOT NULL,
        Name NVARCHAR(50) NOT NULL,
        Website NVARCHAR(50) NOT NULL,
        Address NVARCHAR(50) NOT NULL,
        City NVARCHAR(50) NOT NULL,
        Zip NVARCHAR(50) NOT NULL,
        CONSTRAINT PK_Retailer_RetailerID PRIMARY KEY CLUSTERED (RetailerID),
        CONSTRAINT UK_Retailer_Name UNIQUE (Name)
    );

    SET @Message = 'Completed CREATE TABLE gameDW.Retailer.';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed CREATE Table gameDW.SalesFact.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'gameDW.SalesFact') AND type in (N'U'))
BEGIN
    SET @Message = 'Table gameDW.SalesFact already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN
    CREATE TABLE gameDW.SalesFact
    (
        OrderID INT NOT NULL,
        GameID TINYINT NOT NULL,
        RetailerID TINYINT NOT NULL,
        DateKey DATE NOT NULL,
        Quantity INT NOT NULL,
        TotalAmount MONEY NOT NULL,
        CONSTRAINT PK_SalesFact_OrderID_GameID_RetailerID_DateKey PRIMARY KEY CLUSTERED (OrderID, GameID, RetailerID, DateKey)
    );

    SET @Message = 'Completed CREATE TABLE gameDW.SalesFact.';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed CREATE Table gameDW.Game.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'gameDW.Game') AND type in (N'U'))
BEGIN
    SET @Message = 'Table gameDW.Game already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN
    CREATE TABLE gameDW.Game
    (
        GameID TINYINT NOT NULL,
        TypeID TINYINT NOT NULL,
        PartnerID TINYINT NOT NULL,
        Name NVARCHAR(50) NOT NULL,
        Note NVARCHAR(250) NOT NULL,
        CONSTRAINT PK_Game_GameID PRIMARY KEY CLUSTERED (GameID),
        CONSTRAINT UK_Game_Name UNIQUE (Name)
    );

    SET @Message = 'Completed CREATE TABLE gameDW.Game.';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed CREATE Table gameDW.Type.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'gameDW.Type') AND type in (N'U'))
BEGIN
    SET @Message = 'Table gameDW.Type already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN
    CREATE TABLE gameDW.Type
    (
        TypeID TINYINT NOT NULL,
        Name NVARCHAR(50) NOT NULL,
        Note NVARCHAR(250) NOT NULL,
        CONSTRAINT PK_Type_TypeID PRIMARY KEY CLUSTERED (TypeID),
        CONSTRAINT UK_Type_Name UNIQUE (Name)
    );

    SET @Message = 'Completed CREATE TABLE gameDW.Type.';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed CREATE Table gameDW.Partner.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'gameDW.Partner') AND type in (N'U'))
BEGIN
    SET @Message = 'Table gameDW.Partner already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN
    CREATE TABLE gameDW.Partner
    (
        PartnerID TINYINT NOT NULL,
        Name NVARCHAR(50) NOT NULL,
        Website NVARCHAR(50) NOT NULL,
        City NVARCHAR(50) NOT NULL,
        State NVARCHAR(50) NOT NULL,
        Country NVARCHAR(50) NOT NULL,
        Note NVARCHAR(250) NOT NULL,
        CONSTRAINT PK_Partner_PartnerID PRIMARY KEY CLUSTERED (PartnerID),
        CONSTRAINT UK_Partner_Name UNIQUE (Name)
    );

    SET @Message = 'Completed CREATE TABLE gameDW.Partner.';
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

