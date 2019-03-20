SELECT * FROM a2zmjs.dbo.assets

--control unit字段，三列，无公司标识
SELECT * FROM a2zmjs.dbo.units

select * from MyValuechain_Local.dbo.LM_T_CA_Unit

--field
--asset field 三列，无公司标识 pflag的0,1代表什么？名称前缀是否去掉？
SELECT * FROM a2zmjs.dbo.fields

select * from MyValuechain_Local.dbo.LM_T_CA_Categroy

select * from MyValuechain_Local.dbo.LM_T_CA_Field
--manugacturer两列，无公司标识
SELECT * FROM a2zmjs.dbo.manufacturers

--type三列，无公司标识，type_fam_id未知
SELECT * FROM a2zmjs.dbo.[types]

--status 只要7-12列 两列 Calibration status
SELECT * FROM a2zmjs.dbo.[status] WHERE status_id BETWEEN 7 AND 12
-- 
SELECT * FROM a2zmjs.dbo.[status] WHERE status_id BETWEEN 37 AND 68

--location loc_email全为空，没有owner 三列
SELECT * FROM a2zmjs.dbo.[locations]

--asset
SELECT * FROM a2zmjs.dbo.assets ORDER BY gauge_id
-- gauge_id对应orderindex,gauge_number 对应Name,gauge_type对应Type,gauge_desc对应description， gauge_manufacturer对应Manufacturer，gauge_units对应Units，
--gauge_res对应Resolution，gauge_dim1对应Range1，gauge_dim2对应Range2,gauge_date对应DateAcquired,gauge_storloc对应StorageLocation，gauge_curloc对应CurrentLocation
--gauge_misc5对应custom field,gauge_status对应Status
--gauge_misc2对应owner的名字，gauge_email对应owner的邮箱,gauge_istatus对应Status1
--gauge_note 对应comment
SELECT gauge_misc2,gauge_email FROM a2zmjs.dbo.assets

SELECT * FROM MyValuechain_Local.dbo.LM_T_CA_Assets WHERE  Units IS NOT NULL

SELECT CAST('7x' AS int)

SELECT ISNUMERIC('7x')

EXECUTE a2zmjs.dbo.Pro_AssetMigration 11110

SELECT CONVERT(DATETIME,'20071101')
--检查数据
SELECT * FROM MyValuechain_Local.dbo.LM_T_CA_Unit WHERE CompanyId=11110

SELECT * FROM MyValuechain_Local.dbo.LM_T_CA_Field WHERE CompanyID=11110

SELECT * FROM MyValuechain_Local.dbo.LM_T_CA_Field WHERE CompanyID=11110 order BY Categroy ,OrderIndex 

SELECT * FROM MyValuechain_Local.dbo.LM_T_CA_Assets WHERE CompanyID=11110


--两边的数据排序规则不同，测试的时候需要在查询的列后添加指定排序规则  COLLATE Chinese_PRC_CI_AS
SELECT ID FROM MyValuechain_Local.dbo.LM_T_CA_Field
									WHERE Categroy=(SELECT ID FROM MyValuechain_Local.dbo.LM_T_CA_Categroy WHERE Name=N'Locations')
									AND CompanyID=11110
									AND Name=(SELECT loc_desc COLLATE Chinese_PRC_CI_AS FROM a2zmjs.dbo.[locations] WHERE [loc_id]=1)

SELECT * FROM a2zmjs.dbo.history

SELECT DISTINCT his_asset  FROM a2zmjs.dbo.history
--查找事件的编号，输入内容,查找资产的编号，找到对应的资产guid
SELECT * FROM a2zmjs.dbo.events

SELECT * FROM a2zmjs.dbo.assets WHERE gauge_id=9

SELECT * FROM a2zmjs.dbo.userspass WHERE [user_id]=2

--日期格式需要转换
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

--历史记录的用户id是单独的，怎么和VC同步?