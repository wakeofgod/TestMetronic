SELECT * FROM a2zmjs.dbo.assets

--control unit�ֶΣ����У��޹�˾��ʶ
SELECT * FROM a2zmjs.dbo.units

select * from MyValuechain_Local.dbo.LM_T_CA_Unit

--field
--asset field ���У��޹�˾��ʶ pflag��0,1����ʲô������ǰ׺�Ƿ�ȥ����
SELECT * FROM a2zmjs.dbo.fields

select * from MyValuechain_Local.dbo.LM_T_CA_Categroy

select * from MyValuechain_Local.dbo.LM_T_CA_Field
--manugacturer���У��޹�˾��ʶ
SELECT * FROM a2zmjs.dbo.manufacturers

--type���У��޹�˾��ʶ��type_fam_idδ֪
SELECT * FROM a2zmjs.dbo.[types]

--status ֻҪ7-12�� ���� Calibration status
SELECT * FROM a2zmjs.dbo.[status] WHERE status_id BETWEEN 7 AND 12
-- 
SELECT * FROM a2zmjs.dbo.[status] WHERE status_id BETWEEN 37 AND 68

--location loc_emailȫΪ�գ�û��owner ����
SELECT * FROM a2zmjs.dbo.[locations]

--asset
SELECT * FROM a2zmjs.dbo.assets ORDER BY gauge_id
-- gauge_id��Ӧorderindex,gauge_number ��ӦName,gauge_type��ӦType,gauge_desc��Ӧdescription�� gauge_manufacturer��ӦManufacturer��gauge_units��ӦUnits��
--gauge_res��ӦResolution��gauge_dim1��ӦRange1��gauge_dim2��ӦRange2,gauge_date��ӦDateAcquired,gauge_storloc��ӦStorageLocation��gauge_curloc��ӦCurrentLocation
--gauge_misc5��Ӧcustom field,gauge_status��ӦStatus
--gauge_misc2��Ӧowner�����֣�gauge_email��Ӧowner������,gauge_istatus��ӦStatus1
--gauge_note ��Ӧcomment
SELECT gauge_misc2,gauge_email FROM a2zmjs.dbo.assets

SELECT * FROM MyValuechain_Local.dbo.LM_T_CA_Assets WHERE  Units IS NOT NULL

SELECT CAST('7x' AS int)

SELECT ISNUMERIC('7x')

EXECUTE a2zmjs.dbo.Pro_AssetMigration 11110

SELECT CONVERT(DATETIME,'20071101')
--�������
SELECT * FROM MyValuechain_Local.dbo.LM_T_CA_Unit WHERE CompanyId=11110

SELECT * FROM MyValuechain_Local.dbo.LM_T_CA_Field WHERE CompanyID=11110

SELECT * FROM MyValuechain_Local.dbo.LM_T_CA_Field WHERE CompanyID=11110 order BY Categroy ,OrderIndex 

SELECT * FROM MyValuechain_Local.dbo.LM_T_CA_Assets WHERE CompanyID=11110


--���ߵ������������ͬ�����Ե�ʱ����Ҫ�ڲ�ѯ���к����ָ���������  COLLATE Chinese_PRC_CI_AS
SELECT ID FROM MyValuechain_Local.dbo.LM_T_CA_Field
									WHERE Categroy=(SELECT ID FROM MyValuechain_Local.dbo.LM_T_CA_Categroy WHERE Name=N'Locations')
									AND CompanyID=11110
									AND Name=(SELECT loc_desc COLLATE Chinese_PRC_CI_AS FROM a2zmjs.dbo.[locations] WHERE [loc_id]=1)

SELECT * FROM a2zmjs.dbo.history

SELECT DISTINCT his_asset  FROM a2zmjs.dbo.history
--�����¼��ı�ţ���������,�����ʲ��ı�ţ��ҵ���Ӧ���ʲ�guid
SELECT * FROM a2zmjs.dbo.events

SELECT * FROM a2zmjs.dbo.assets WHERE gauge_id=9

SELECT * FROM a2zmjs.dbo.userspass WHERE [user_id]=2

--���ڸ�ʽ��Ҫת��
SELECT CONVERT(DATETIME,'2008/08/08 19:51')

SELECT CONVERT(DATETIME,'200808081951')

SELECT ISDATE('2008/08/08 19:51')

DECLARE @DateString NVARCHAR(50)
SELECT @DateString='200808081951'
SELECT @DateString=SUBSTRING(@DateString,1,4)+'/'+SUBSTRING(@DateString,5,2)+'/'+SUBSTRING(@DateString,7,2)+' '+SUBSTRING(@DateString,9,2)+':'+SUBSTRING(@DateString,11,2)
SELECT ISDATE(@DateString)
SELECT CONVERT(DATETIME,@DateString)
PRINT @DateString

SELECT * FROM MyValuechain_Local.dbo.LM_T_CA_AssetActionLog

SELECT * FROM MyValuechain_Local.dbo.LM_T_CA_Assets WHERE CompanyID=11110

--��ʷ��¼���û�id�ǵ����ģ���ô��VCͬ��?