USE a2zmjs
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name='Pro_AssetMigration_part2')
	DROP PROCEDURE Pro_AssetMigration_part2
GO

CREATE PROCEDURE  Pro_AssetMigration_part2
(@CompanyId int)
AS 
BEGIN
	DECLARE @EventId INT ,
			@EventText NVARCHAR(500),
			@AssetId INT,
			@AssetGuid UNIQUEIDENTIFIER,
			@RecordTimeText NVARCHAR(50),
			@RecordTime DATETIME
	
	DECLARE Cur_History CURSOR
    FOR SELECT his_asset,his_date,his_event FROM a2zmjs.dbo.history
	OPEN Cur_History
	FETCH NEXT FROM Cur_History INTO @AssetId,@RecordTimeText,@EventId
	WHILE @@FETCH_STATUS=0
		BEGIN
			SELECT @RecordTimeText=SUBSTRING(@RecordTimeText,1,4)+'/'+SUBSTRING(@RecordTimeText,5,2)+'/'+SUBSTRING(@RecordTimeText,7,2)+' '+SUBSTRING(@RecordTimeText,9,2)+':'+SUBSTRING(@RecordTimeText,11,2)
			IF(ISDATE(@RecordTimeText)=1)
				BEGIN
					SELECT @RecordTime=CONVERT(DATETIME,@RecordTimeText)
				END 
			ELSE 
				BEGIN
					SELECT @RecordTime='1900/01/01'
				END 
			SELECT  @AssetGuid = ( SELECT TOP 1 ID FROM MyValuechain_Local.dbo.LM_T_CA_Assets
										WHERE Name=(SELECT gauge_number  FROM a2zmjs.dbo.assets WHERE gauge_id =@AssetId )
										AND CompanyID=@CompanyId)

			SELECT @EventText= (SELECT TOP 1 event_desc FROM a2zmjs.dbo.[events] WHERE event_id=@EventId )

			INSERT INTO MyValuechain_Local.dbo.LM_T_CA_AssetActionLog
			(
			    ID,
			    AssetGuid,
			    Operator,
			    EventContent,
			    EnvenType,
			    RecordTime,
			    IsDelete,
			    IsEnable,
				OperateUser
			)
			VALUES
			(   NEWID(),      -- ID - uniqueidentifier
			    ISNULL(@AssetGuid,N'00000000-0000-0000-0000-000000000000') ,      -- AssetGuid - uniqueidentifier
			    N'00000000-0000-0000-0000-000000000000',      -- Operator - uniqueidentifier
			    @EventText,       -- EventContent - nvarchar(max)
			    0,         -- EnvenType - int
			    @RecordTime, -- RecordTime - datetime
			    0,      -- IsDelete - bit
			    1,       -- IsEnable - bit
				-1
			    )

			FETCH NEXT FROM Cur_History INTO @AssetId,@RecordTimeText,@EventId
		END
    CLOSE Cur_History
	DEALLOCATE Cur_History    
END 
            
    