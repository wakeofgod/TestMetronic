USE a2zmjs
go

--ALTER DATABASE MyValuechain_Local COLLATE SQL_Latin1_General_CP1_CI_AS
--ALTER DATABASE MyValuechain_Local SINGLE_USER WITH ROLLBACK IMMEDIATE
--go
if exists(select * from sys.objects where name='Pro_AssetMigration')
begin
	drop procedure Pro_AssetMigration
end
go

create procedure Pro_AssetMigration
(@CompanyId int)
as 
	begin
		declare @UnitId int,
				@UnitName nvarchar(50),
				@UnitNumber int,
				@CateGoryGuid UNIQUEIDENTIFIER,
				@OrderIndex INT,
				@TypeId  INT,
				@TypeGuid UNIQUEIDENTIFIER,
				@Description NVARCHAR(500),
				@ManufacturerId INT,
				@ManufacturerGuid UNIQUEIDENTIFIER,
				@UnitText NVARCHAR(40),
				@Resolution REAL,
				@ResolutionText NVARCHAR(10),
				@Range1 REAL,
				@Range2 REAL,
				@DateAcquiredText NVARCHAR(8),
				@DateAcquired DATETIME,
				@StorageLocId INT,
				@StorageLocGuid UNIQUEIDENTIFIER,
				@CurrentLocId INT,
				@CurrentLocGuid UNIQUEIDENTIFIER,
				@CalibrationStatusId INT,
				@CalibrationStatusGuid UNIQUEIDENTIFIER,
                @StatusId INT,
				@StatusGuid UNIQUEIDENTIFIER

		declare Cur_Unit cursor
		for select unit_id,unit_desc,unit_qty from a2zmjs.dbo.units
		open Cur_Unit
		fetch next from Cur_Unit into @UnitId,@UnitName,@UnitNumber
		while @@FETCH_STATUS=0
			begin
				if not exists(select * from MyValuechain_Local.dbo.LM_T_CA_Unit where Name=@UnitName and UnitNumber=@UnitNumber and CompanyId=@CompanyId)
					INSERT INTO MyValuechain_Local.dbo.LM_T_CA_Unit(ID,[Name],[UnitNumber],[CompanyId],[CreateTime],[CreateBy],[CreateUser],IsDelete,IsEnable)
					VALUES(NEWID(),@UnitName,@UnitNumber,@CompanyId,GETDATE(),N'00000000-0000-0000-0000-000000000000',-1,0,1)
				fetch next from Cur_Unit into @UnitId,@UnitName,@UnitNumber
			end
		close Cur_Unit
		deallocate Cur_Unit

		--import asset field
		select top 1 @CateGoryGuid= ID from MyValuechain_Local.dbo.LM_T_CA_Categroy where Name=N'Asset Fields'
		DECLARE Cur_AField CURSOR
		FOR SELECT id,colname  FROM a2zmjs.dbo.fields
		OPEN Cur_AField
		FETCH NEXT FROM Cur_AField INTO @UnitId,@UnitName
		WHILE @@FETCH_STATUS=0
			BEGIN
				SELECT @OrderIndex=(SELECT COUNT(*) FROM MyValuechain_Local.dbo.LM_T_CA_Field WHERE CompanyID=@CompanyId AND Categroy=@CateGoryGuid)+1
				INSERT INTO MyValuechain_Local.dbo.LM_T_CA_Field
				(
				    ID,
				    Name,
				    CreateBy,
				    CompanyID,
				    OrderIndex,
				    Status,
				    Categroy,
				    IsCopy,
				    CopyFrom,
				    IsDelete,
				    IsEnable,
				    CreateUser
				)
				VALUES
				(   NEWID(), -- ID - uniqueidentifier
				    @UnitName,  -- Name - nvarchar(50)
				    N'00000000-0000-0000-0000-000000000000', -- CreateBy - uniqueidentifier
				    @CompanyId,    -- CompanyID - int
				    @OrderIndex,    -- OrderIndex - int
				    0,    -- Status - int
				    @CateGoryGuid, -- Categroy - uniqueidentifier
				    0, -- IsCopy - bit
				    NULL, -- CopyFrom - uniqueidentifier
				    0, -- IsDelete - bit
				    1, -- IsEnable - bit
				    -1     -- CreateUser - int
				    )
				FETCH NEXT FROM Cur_AField INTO @UnitId,@UnitName
			END
        CLOSE Cur_AField
		DEALLOCATE Cur_AField
		    
		--insert into MyValuechain_Local.dbo.LM_T_CA_Field(ID,[Name],CompanyID,[Status],Categroy,IsDelete,IsEnable,[CreateBy],[CreateUser],[IsCopy],[OrderIndex])
		--select NEWID(),
		--	   colname,
		--	   @CompanyId,
		--	   0,
		--	   @CateGoryGuid,
		--	   0,1,
		--	   N'00000000-0000-0000-0000-000000000000',-1,0,
		--	   (SELECT COUNT(*) FROM MyValuechain_Local.dbo.LM_T_CA_Field WHERE CompanyID=@CompanyId AND Categroy=@CateGoryGuid)
  --      from a2zmjs.dbo.fields

		--import manugacturer field
		select top 1 @CateGoryGuid= ID from MyValuechain_Local.dbo.LM_T_CA_Categroy where Name=N'Manufacturer'
		DECLARE Cur_MField CURSOR
		FOR SELECT manuf_id,manuf_name FROM a2zmjs.dbo.manufacturers
		OPEN Cur_MField
		FETCH NEXT FROM Cur_MField INTO @UnitId,@UnitName
		WHILE @@FETCH_STATUS=0
			BEGIN
				SELECT @OrderIndex=(SELECT COUNT(*) FROM MyValuechain_Local.dbo.LM_T_CA_Field WHERE CompanyID=@CompanyId AND Categroy=@CateGoryGuid)+1
				INSERT INTO MyValuechain_Local.dbo.LM_T_CA_Field
				(
				    ID,
				    Name,
				    CreateBy,
				    CompanyID,
				    OrderIndex,
				    Status,
				    Categroy,
				    IsCopy,
				    CopyFrom,
				    IsDelete,
				    IsEnable,
				    CreateUser
				)
				VALUES
				(   NEWID(), -- ID - uniqueidentifier
				    @UnitName,  -- Name - nvarchar(50)
				    N'00000000-0000-0000-0000-000000000000', -- CreateBy - uniqueidentifier
				    @CompanyId,    -- CompanyID - int
				    @OrderIndex,    -- OrderIndex - int
				    0,    -- Status - int
				    @CateGoryGuid, -- Categroy - uniqueidentifier
				    0, -- IsCopy - bit
				    NULL, -- CopyFrom - uniqueidentifier
				    0, -- IsDelete - bit
				    1, -- IsEnable - bit
				    -1     -- CreateUser - int
				    )
				FETCH NEXT FROM Cur_MField INTO @UnitId,@UnitName
			END 
		CLOSE Cur_MField
		DEALLOCATE Cur_MField

		--import type field

		select top 1 @CateGoryGuid= ID from MyValuechain_Local.dbo.LM_T_CA_Categroy where Name=N'Types'
		DECLARE Cur_TField CURSOR
		FOR SELECT type_id,type_desc FROM  a2zmjs.dbo.[types]
		OPEN Cur_TField
		FETCH NEXT FROM Cur_TField INTO @UnitId,@UnitName
		WHILE @@FETCH_STATUS=0
			BEGIN
				SELECT @OrderIndex=(SELECT COUNT(*) FROM MyValuechain_Local.dbo.LM_T_CA_Field WHERE CompanyID=@CompanyId AND Categroy=@CateGoryGuid)+1
				INSERT INTO MyValuechain_Local.dbo.LM_T_CA_Field
				(
				    ID,
				    Name,
				    CreateBy,
				    CompanyID,
				    OrderIndex,
				    Status,
				    Categroy,
				    IsCopy,
				    CopyFrom,
				    IsDelete,
				    IsEnable,
				    CreateUser
				)
				VALUES
				(   NEWID(), -- ID - uniqueidentifier
				    @UnitName,  -- Name - nvarchar(50)
				    N'00000000-0000-0000-0000-000000000000', -- CreateBy - uniqueidentifier
				    @CompanyId,    -- CompanyID - int
				    @OrderIndex,    -- OrderIndex - int
				    0,    -- Status - int
				    @CateGoryGuid, -- Categroy - uniqueidentifier
				    0, -- IsCopy - bit
				    NULL, -- CopyFrom - uniqueidentifier
				    0, -- IsDelete - bit
				    1, -- IsEnable - bit
				    -1     -- CreateUser - int
				    )
				FETCH NEXT FROM Cur_TField INTO @UnitId,@UnitName
			END 
		CLOSE Cur_TField
		DEALLOCATE Cur_TField

		--import Calibration status field
		select top 1 @CateGoryGuid= ID from MyValuechain_Local.dbo.LM_T_CA_Categroy where Name=N'Calibration Status'
		DECLARE Cur_CSField CURSOR
		FOR SELECT status_id,status_desc FROM a2zmjs.dbo.[status] WHERE status_id BETWEEN 7 AND 12
		OPEN Cur_CSField
		FETCH NEXT FROM Cur_CSField INTO @UnitId,@UnitName
		WHILE @@FETCH_STATUS=0
			BEGIN
				SELECT @OrderIndex=(SELECT COUNT(*) FROM MyValuechain_Local.dbo.LM_T_CA_Field WHERE CompanyID=@CompanyId AND Categroy=@CateGoryGuid)+1
				INSERT INTO MyValuechain_Local.dbo.LM_T_CA_Field
				(
				    ID,
				    Name,
				    CreateBy,
				    CompanyID,
				    OrderIndex,
				    Status,
				    Categroy,
				    IsCopy,
				    CopyFrom,
				    IsDelete,
				    IsEnable,
				    CreateUser
				)
				VALUES
				(   NEWID(), -- ID - uniqueidentifier
				    @UnitName,  -- Name - nvarchar(50)
				    N'00000000-0000-0000-0000-000000000000', -- CreateBy - uniqueidentifier
				    @CompanyId,    -- CompanyID - int
				    @OrderIndex,    -- OrderIndex - int
				    0,    -- Status - int
				    @CateGoryGuid, -- Categroy - uniqueidentifier
				    0, -- IsCopy - bit
				    NULL, -- CopyFrom - uniqueidentifier
				    0, -- IsDelete - bit
				    1, -- IsEnable - bit
				    -1     -- CreateUser - int
				    )
				FETCH NEXT FROM Cur_CSField INTO @UnitId,@UnitName
			END 
		CLOSE Cur_CSField
		DEALLOCATE Cur_CSField
		--import status field
		select top 1 @CateGoryGuid= ID from MyValuechain_Local.dbo.LM_T_CA_Categroy where Name=N'Status'
		DECLARE Cur_SField CURSOR
		FOR SELECT status_id,status_desc FROM a2zmjs.dbo.[status] WHERE status_id BETWEEN 37 AND 68
		OPEN Cur_SField
		FETCH NEXT FROM Cur_SField INTO @UnitId,@UnitName
		WHILE @@FETCH_STATUS=0
			BEGIN
 				SELECT @OrderIndex=(SELECT COUNT(*) FROM MyValuechain_Local.dbo.LM_T_CA_Field WHERE CompanyID=@CompanyId AND Categroy=@CateGoryGuid)+1
				INSERT INTO MyValuechain_Local.dbo.LM_T_CA_Field
				(
				    ID,
				    Name,
				    CreateBy,
				    CompanyID,
				    OrderIndex,
				    Status,
				    Categroy,
				    IsCopy,
				    CopyFrom,
				    IsDelete,
				    IsEnable,
				    CreateUser
				)
				VALUES
				(   NEWID(), -- ID - uniqueidentifier
				    @UnitName,  -- Name - nvarchar(50)
				    N'00000000-0000-0000-0000-000000000000', -- CreateBy - uniqueidentifier
				    @CompanyId,    -- CompanyID - int
				    @OrderIndex,    -- OrderIndex - int
				    0,    -- Status - int
				    @CateGoryGuid, -- Categroy - uniqueidentifier
				    0, -- IsCopy - bit
				    NULL, -- CopyFrom - uniqueidentifier
				    0, -- IsDelete - bit
				    1, -- IsEnable - bit
				    -1     -- CreateUser - int
				    )
				FETCH NEXT FROM Cur_SField INTO @UnitId,@UnitName           
			END 
		CLOSE Cur_SField
		DEALLOCATE Cur_SField

		SELECT TOP 1 @CateGoryGuid= ID FROM MyValuechain_Local.dbo.LM_T_CA_Categroy WHERE Name=N'Locations'
		DECLARE Cur_LocField CURSOR
		FOR SELECT loc_id,loc_desc FROM a2zmjs.dbo.[locations]
		OPEN Cur_LocField
		FETCH NEXT FROM Cur_LocField INTO @UnitId,@UnitName
		WHILE @@FETCH_STATUS=0
			BEGIN
 				SELECT @OrderIndex=(SELECT COUNT(*) FROM MyValuechain_Local.dbo.LM_T_CA_Field WHERE CompanyID=@CompanyId AND Categroy=@CateGoryGuid)+1
				INSERT INTO MyValuechain_Local.dbo.LM_T_CA_Field
				(
				    ID,
				    Name,
				    CreateBy,
				    CompanyID,
				    OrderIndex,
				    Status,
				    Categroy,
				    IsCopy,
				    CopyFrom,
				    IsDelete,
				    IsEnable,
				    CreateUser
				)
				VALUES
				(   NEWID(), -- ID - uniqueidentifier
				    @UnitName,  -- Name - nvarchar(50)
				    N'00000000-0000-0000-0000-000000000000', -- CreateBy - uniqueidentifier
				    @CompanyId,    -- CompanyID - int
				    @OrderIndex,    -- OrderIndex - int
				    0,    -- Status - int
				    @CateGoryGuid, -- Categroy - uniqueidentifier
				    0, -- IsCopy - bit
				    NULL, -- CopyFrom - uniqueidentifier
				    0, -- IsDelete - bit
				    1, -- IsEnable - bit
				    -1     -- CreateUser - int
				    )
				FETCH NEXT FROM Cur_LocField INTO @UnitId,@UnitName
			END 
		CLOSE Cur_LocField
		DEALLOCATE Cur_LocField

		--cutom field 动态字段无法匹配，owner的邮箱无法匹配,评论没有用户无法匹配
		DECLARE Cur_Asset CURSOR 
		FOR SELECT gauge_id,gauge_number,gauge_type,gauge_desc,gauge_manufacturer,gauge_units,gauge_res,gauge_dim1,gauge_dim2,gauge_date,gauge_storloc,
		gauge_curloc,gauge_status,gauge_istatus  FROM a2zmjs.dbo.assets ORDER BY gauge_id
		OPEN Cur_Asset
		FETCH NEXT FROM Cur_Asset INTO @UnitId,@UnitName,@TypeId,@Description,@ManufacturerId,@UnitText,@ResolutionText,@Range1,@Range2,@DateAcquiredText,
									   @StorageLocId,@CurrentLocId,@StatusId,@CalibrationStatusId
		WHILE @@FETCH_STATUS=0
			BEGIN
				SELECT @OrderIndex=( SELECT COUNT(*) FROM MyValuechain_Local.dbo.LM_T_CA_Assets WHERE CompanyID=@CompanyId)+1
				SELECT @TypeGuid= (SELECT TOP 1 ID  FROM MyValuechain_Local.dbo.LM_T_CA_Field
									WHERE  Categroy=(SELECT ID FROM MyValuechain_Local.dbo.LM_T_CA_Categroy where Name=N'Types') 
									AND CompanyID=@CompanyId 
									AND Name=(SELECT Name COLLATE Chinese_PRC_CI_AS FROM a2zmjs.dbo.[types] WHERE [type_id]=@TypeId))
				SELECT @ManufacturerGuid=(SELECT TOP 1 ID FROM MyValuechain_Local.dbo.LM_T_CA_Field
										  WHERE Categroy=(SELECT ID FROM MyValuechain_Local.dbo.LM_T_CA_Categroy WHERE name =N'Manufacturer')
										   AND CompanyID=@CompanyId
										   AND Name=(SELECT manuf_name COLLATE Chinese_PRC_CI_AS FROM a2zmjs.dbo.[manufacturers] WHERE [manuf_id]=@ManufacturerId))
				IF(ISNUMERIC(@ResolutionText)=1)
					BEGIN
						SELECT @Resolution=CONVERT(REAL,@ResolutionText)
					END 
				ELSE
					BEGIN
						SELECT @Resolution=0
					END 

				SELECT @DateAcquired=CONVERT(DATETIME,@DateAcquiredText)
				SELECT @StorageLocGuid=(SELECT TOP 1 ID FROM MyValuechain_Local.dbo.LM_T_CA_Field
									WHERE Categroy=(SELECT ID FROM MyValuechain_Local.dbo.LM_T_CA_Categroy WHERE Name=N'Locations')
									AND CompanyID=@CompanyId
									AND Name=(SELECT loc_desc COLLATE Chinese_PRC_CI_AS FROM a2zmjs.dbo.[locations] WHERE [loc_id]=@StorageLocId))
				SELECT @CurrentLocGuid=(SELECT TOP 1 ID FROM MyValuechain_Local.dbo.LM_T_CA_Field
									WHERE Categroy=(SELECT ID FROM MyValuechain_Local.dbo.LM_T_CA_Categroy WHERE Name=N'Locations')
									AND CompanyID=@CompanyId
									AND Name=(SELECT loc_desc COLLATE Chinese_PRC_CI_AS FROM a2zmjs.dbo.[locations] WHERE [loc_id]=@CurrentLocId))
				SELECT @StatusGuid=(SELECT TOP 1 ID FROM MyValuechain_Local.dbo.LM_T_CA_Field
									WHERE Categroy=(SELECT ID FROM MyValuechain_Local.dbo.LM_T_CA_Categroy WHERE Name=N'Status')
									AND CompanyID=@CompanyId
									AND Name=(SELECT TOP 1 status_desc COLLATE Chinese_PRC_CI_AS FROM a2zmjs.dbo.[status] WHERE [status_id]=@StatusId AND status_id BETWEEN 37 AND 68))
				SELECT @CalibrationStatusGuid=(SELECT TOP 1 ID FROM MyValuechain_Local.dbo.LM_T_CA_Field
									WHERE Categroy=(SELECT ID FROM MyValuechain_Local.dbo.LM_T_CA_Categroy WHERE Name=N'Status')
									AND CompanyID=@CompanyId
									AND Name=(SELECT status_desc COLLATE Chinese_PRC_CI_AS FROM a2zmjs.dbo.[status] WHERE [status_id]=@CalibrationStatusId AND status_id BETWEEN 7 AND 12))
				INSERT INTO MyValuechain_Local.dbo.LM_T_CA_Assets
				(
				    ID,
				    Name,
				    CompanyID,
				    Creator,
				    Icon,
				    FileExtName,
				    FileName,
				    Description,
				    AssetOwner,
				    Manufacturer,
				    CurrentLocation,
				    StorageLocation,
				    Type,
				    Status,
				    DateAcquired,
				    OrderIndex,
				    IsDelete,
				    IsEnable,
				    Status1,
				    Sheet,
				    Units,
				    Resolution,
				    Range1,
				    Range2,
				    EquipType,
				    CreateUser,
				    OwnerUser,
				    QRCode
				)
				VALUES
				(   NEWID(),      -- ID - uniqueidentifier
				    @UnitName,       -- Name - nvarchar(40)
				    @CompanyId,         -- CompanyID - int
				    N'00000000-0000-0000-0000-000000000000',      -- Creator - uniqueidentifier
				    NULL,      -- Icon - varbinary(max)
				    N'',       -- FileExtName - nvarchar(max)
				    N'',       -- FileName - nvarchar(max)
				    N'',       -- Description - nvarchar(500)
				    N'00000000-0000-0000-0000-000000000000',      -- AssetOwner - uniqueidentifier
				    @ManufacturerGuid,      -- Manufacturer - uniqueidentifier
				    @CurrentLocGuid,      -- CurrentLocation - uniqueidentifier
				    @StorageLocGuid,      -- StorageLocation - uniqueidentifier
				    @TypeGuid,      -- Type - uniqueidentifier
				    ISNULL(@CalibrationStatusGuid,N'00000000-0000-0000-0000-000000000000'),      -- Status - uniqueidentifier
				    @DateAcquired, -- DateAcquired - datetime
				    @OrderIndex,         -- OrderIndex - int
				    0,      -- IsDelete - bit
				    1,      -- IsEnable - bit
				    ISNULL(@StatusGuid,N'00000000-0000-0000-0000-000000000000'),      -- Status1 - uniqueidentifier
				    NULL,      -- Sheet - uniqueidentifier
				    @UnitText,       -- Units - nvarchar(40)
				    @Resolution,       -- Resolution - real
				    @Range1,       -- Range1 - real
				    @Range2,       -- Range2 - real
				    0,         -- EquipType - int
				    -1,         -- CreateUser - int
				    -1,         -- OwnerUser - int
				    N''        -- QRCode - nvarchar(30)
				    )

				FETCH NEXT FROM Cur_Asset INTO @UnitId,@UnitName,@TypeId,@Description,@ManufacturerId,@UnitText,@ResolutionText,@Range1,@Range2,@DateAcquiredText,
									   @StorageLocId,@CurrentLocId,@StatusId,@CalibrationStatusId
			END 
		CLOSE Cur_Asset
		DEALLOCATE Cur_Asset
	end
