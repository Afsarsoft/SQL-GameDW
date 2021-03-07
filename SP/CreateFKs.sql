CREATE OR ALTER PROCEDURE gameDW.CreateFKs
AS
/***************************************************************************************************
File: CreateFKs.sql
----------------------------------------------------------------------------------------------------
Procedure:      gameDW.CreateFKs
Create Date:    2021-03-01 (yyyy-mm-dd)
Author:         Surush Cyrus
Description:    Creates FKs for all needed gameDW tables  
Call by:        TBD, UI, Add hoc
Steps:          NA
Parameter(s):   None
Usage:          EXEC gameDW.CreateFKs
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
SET @ErrorText = 'Failed adding FOREIGN KEY for Table gameDW.Game.';

IF EXISTS (SELECT *
FROM sys.foreign_keys
WHERE object_id = OBJECT_ID(N'gameDW.FK_Game_Type_TypeID')
  AND parent_object_id = OBJECT_ID(N'gameDW.Game')
)
BEGIN
  SET @Message = 'FOREIGN KEY for Table gameDW.Game already exist, skipping....';
  RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN
  ALTER TABLE gameDW.Game
   ADD CONSTRAINT FK_Game_Type_TypeID FOREIGN KEY (TypeID)
      REFERENCES gameDW.Type (TypeID),
      CONSTRAINT FK_Game_Partner_PartnerID FOREIGN KEY (PartnerID)
  REFERENCES gameDW.Partner (PartnerID);

  SET @Message = 'Completed adding FOREIGN KEY for TABLE gameDW.Game.';
  RAISERROR(@Message, 0,1) WITH NOWAIT;
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed adding FOREIGN KEY for Table gameDW.FactSales.';

IF EXISTS (SELECT *
FROM sys.foreign_keys
WHERE object_id = OBJECT_ID(N'gameDW.FK_FactSales_Retailer_RetailerID')
  AND parent_object_id = OBJECT_ID(N'gameDW.FactSales')
)
BEGIN
  SET @Message = 'FOREIGN KEY for Table gameDW.FactSales already exist, skipping....';
  RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN
  ALTER TABLE gameDW.FactSales
   ADD CONSTRAINT FK_FactSales_Retailer_RetailerID FOREIGN KEY (RetailerID)
      REFERENCES gameDW.Retailer (RetailerID),
    CONSTRAINT FK_FactSales_Game_GameID FOREIGN KEY (GameID)
      REFERENCES gameDW.Game (GameID);

  SET @Message = 'Completed adding FOREIGN KEY for TABLE gameDW.FactSales.';
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

