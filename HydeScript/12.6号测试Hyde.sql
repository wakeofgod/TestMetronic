select * from MyValuechain_Hyde.dbo.LM_T_Users where FirstName like '%sue'
select * from MyValuechain_Hyde.dbo.LM_T_Users where LoginName like '%admin'
update MyValuechain_Hyde.dbo.LM_T_Users set Password='h5KTFG/tWWzveqauc3IZJg==',SuperUser=1 where UserID=10
--一直显示在还原中
RESTORE DATABASE MyValuechain WITH RECOVERY
RESTORE DATABASE mydatacentre WITH RECOVERY
--需要注释掉EntityModel.DataCentre\OpenBook\BLLReportSettings.cs下922行的遍历集合，不然添加字段一直卡着
--新添加了一个dataset，就按照reporttypeId降序查询来，然后它的dataname就是存放数据源的表
--遍历sale orders表
select * from dc_t_openbook_reporttype  order by ReportTypeId desc
--根据名字会找到一排，怎么识别唯一？在页面上可以用框架查看编号,查找数据源
select * from MyDataCentre_Hyde.dbo.DC_T_OpenBook_ReportType where ReportTypeName like '%DSA%'
select * from MyDataCentre_Hyde.[dbo].dc_t_openbook_reporttype where ReportTypeName like '%sales orders'
select * from MyDataCentre_Hyde.[dbo].[8e133ecd-5692-4a42-86b8-6e338f76f08d]
select * from MyDataCentre_Hyde.[dbo].dc_t_openbook_reporttype where ReportTypeId=1242
select * from MyDataCentre_Hyde.[dbo].dc_t_openbook_reporttype where ReportTypeId=1395
select * from MyDataCentre_Hyde.[dbo].dc_t_openbook_reporttype order by ReportTypeId desc
--select * from DC_T_OpenBook_ColumnSetting where ReportType=1406 order by ID
--根据reportType和title查找字段真正的列名FieldXXXX
select * from MyDataCentre_Hyde.[dbo]. DC_T_OpenBook_ColumnSetting where ReportType=241
select * from MyDataCentre_Hyde.[dbo]. DC_T_OpenBook_ColumnSetting where ReportType=1242
select * from MyDataCentre_Hyde.[dbo]. DC_T_OpenBook_ColumnSetting where ReportType=1395
select * from MyDataCentre_Hyde.[dbo].DC_T_OpenBook_ColumnSetting where ReportType=1433 order by ID

	declare
		    @TableName				nvarchar(100),
			@Column1				nvarchar(100),
			@Column2				nvarchar(100),
			@NameValue				nvarchar(100),
			@CoreValue				nvarchar(100),
			@Id						nvarchar(100),
			@sql					nvarchar(max)		
    select @TableName='ExamScore'
	select @Column1='StuName'
	select @Column2='StuCore'	  
	select @sql= 'declare Cur_Cal cursor for '
	select @sql+=' select '+ @Column1+','+@Column2+',ID from '+@TableName 
	select @sql+=' open Cur_Cal '		
	select @sql+='fetch next from Cur_Cal into  @NameValue,@CoreValue,@Id '	
	select @sql+='while @@FETCH_STATUS=0 ' 
	select @sql+='begin '
	select @sql+='print @NameValue '
	select @sql+=' fetch next from Cur_Cal into @NameValue,@CoreValue,@Id '
	select @sql+='end '
	select @sql+=' close Cur_Cal '
	select @sql+=' deallocate Cur_Cal'
	print @sql
	--打印出来的sql可以单独执行，但是放在exec后面就是各种语法错误
	--Exec (@sql)
	exec sp_executesql @sql
go
 --declare @TableName nvarchar(100),@Column1 nvarchar(100),@Column2 nvarchar(100),@NameValue nvarchar(100),@CoreValue int,@Id int
 -- select @TableName='ExamScore' 
 -- select @Column1='StuName'
 -- select @Column2='StuCore' 
 -- --exec(' select '+@Column1+ ','+@Column2+' from '+@TableName)
 -- exec( 'declare Cur_Cal cursor for  select '+@Column1+','+@Column2+',ID from '+@TableName+' into '+@NameValue+','+@CoreValue+','+@Id+'  open Cur_Cal fetch next from Cur_Cal into'+ @NameValue+','+@CoreValue+','+@Id +' while @@FETCH_STATUS=0 begin print @NameValue  fetch next from Cur_Cal into ' +@NameValue+','+@CoreValue+','+@Id +'end close Cur_Cal  deallocate Cur_Cal')
--sales orders
select COUNT(ID) from [dbo].[8e133ecd-5692-4a42-86b8-6e338f76f08d]
--WIP Sales
select COUNT(ID) from [dbo].[eaa78e26-d387-4dfa-b71e-be4690feb65a]
--New Delivery Report
select COUNT(ID) from [dbo].[239e008b-1b35-46df-a398-42af1c7fe8d7]

select count(*) from [dbo].[8e133ecd-5692-4a42-86b8-6e338f76f08d] sales
inner join [dbo].[eaa78e26-d387-4dfa-b71e-be4690feb65a] wips on sales.Field2061=wips.Field3067
select DATENAME(DAY,'2017/07/18')
select Field3077 from  dbo.[eaa78e26-d387-4dfa-b71e-be4690feb65a] wip where wip.Field3077 like '%2017-07-18'
select Field3077,Field3090,Field3083 from dbo.[eaa78e26-d387-4dfa-b71e-be4690feb65a] wip 
inner join dbo.[8e133ecd-5692-4a42-86b8-6e338f76f08d] sales on wip.Field3067 =sales.Field2061

select * from [dbo].[eaa78e26-d387-4dfa-b71e-be4690feb65a]
execute pro_CalculateFinal
select * from TestMiddleValue order by CntrctYear asc ,CntrctWeekNum asc
select * from TestFinalValue

select * from TestMiddleValue order by CntrctYear asc,CntrctWeekNum asc
insert into  TestFinalValue ([Week/Year])
select  Final  from 
(select top 100 percent row_number() over(order by CntrctYear asc, CntrctWeekNum asc ) as rowid,  CONCAT( cast( CntrctWeekNum as nvarchar(100)),'/',cast( CntrctYear as nvarchar(100))) as Final,CntrctYear,CntrctWeekNum from TestMiddleValue group by CntrctYear,CntrctWeekNum ) t order by t.rowid
--在本地新建dataset，取名finalvalues， 对应的表是[28beb316-1006-40fc-9003-d1aa3af8ba1f]，12个字段
select * from MyDataCentre_Hyde.[dbo].DC_T_OpenBook_ReportType order by ReportTypeId desc 
select * from MyDataCentre_Hyde.[dbo].[28beb316-1006-40fc-9003-d1aa3af8ba1f]

--检查middle value
select ISNULL( count(*),0) ContractedDelivery from TestMiddleValue where CntrctWeekNum=40 and CntrctYear=2017
select  COUNT(*) ActualDeliveryLines from TestMiddleValue where CntrctWeekNum=40 and CntrctYear=2017 and WeekDelivered<=53 and Delivered='Delivered'
select COUNT(*) ArrearsForecastedLines from TestMiddleValue where DelivWeekNum=40 and DelivYear=2017 and Rescheduled='Rescheduled'
select COUNT(*)ArrearsDeliveredLines from TestMiddleValue where DelivYear=2017 and DelivWeekNum=40 and WeekDelivered<53
select * from TestFinalValue where WeekNum=40 and YearNum=2017

select * from TestMiddleValue where DelivYear=40 and DelivWeekNum=2017 and WeekDelivered<53

select Field2061 from [dbo].[8e133ecd-5692-4a42-86b8-6e338f76f08d] sales 
where sales.Field2061 not in (select Field3067 from dbo.[eaa78e26-d387-4dfa-b71e-be4690feb65a] wips)

select COUNT(*) from [dbo].[8e133ecd-5692-4a42-86b8-6e338f76f08d] sales 
inner join [dbo].[239e008b-1b35-46df-a398-42af1c7fe8d7] newdel on sales.Field2061 =newdel.Field4559 COLLATE Chinese_PRC_CI_AS

select distinct Field2061 from [dbo].[8e133ecd-5692-4a42-86b8-6e338f76f08d] sales 
select * from [dbo].[239e008b-1b35-46df-a398-42af1c7fe8d7] newdel
select * from [dbo].[239e008b-1b35-46df-a398-42af1c7fe8d7] newdel where newdel.Field4559 COLLATE Chinese_PRC_CI_AS in (select Field2061  from [dbo].[8e133ecd-5692-4a42-86b8-6e338f76f08d] sales)  

select top 20 ID,Field2061 from (select ROW_NUMBER() over(order by field2061) as rowid,sales.* from [dbo].[8e133ecd-5692-4a42-86b8-6e338f76f08d] sales) t where t.rowid >1*20

alter table DC_T_OpenBook_ChartSetting_MultiYAxis add Y2Stylevalue int
GO

update DC_T_OpenBook_ChartSetting_MultiYAxis set Y2Stylevalue = 0
GO

select * from [dbo].DC_T_OpenBook_ChartSetting_MultiYAxis
select * from [dbo].[eaa78e26-d387-4dfa-b71e-be4690feb65a] wips where wips.Field3077 like'%j' or wips.Field3078 like'%j'
select DATENAME(YEAR,'2017-12-12')
select DATENAME(WEEK,'2017-12-12')
select DATENAME(MONTH,'2017-12-12')
select DATEDIFF(DAY,'2017-12-12',GETDATE())
select * from [dbo].[239e008b-1b35-46df-a398-42af1c7fe8d7] newdel where newdel.Field4558 like'%j'
select Field3077,Field3078 from [dbo].[eaa78e26-d387-4dfa-b71e-be4690feb65a] wips 

select datepart(MONTH,'2017-12-12')

select ReportTypeName,DataName from dc_t_openbook_reporttype  order by ReportTypeId desc
select * from [dbo].[28beb316-1006-40fc-9003-d1aa3af8ba1f]
select * from [dbo].[148879a0-c7d8-43ce-8fe8-cd62ef161ad0]
select * from [dbo].[148879a0-c7d8-43ce-8fe8-cd62ef161ad0_filter]

SELECT TOP 1000 [ID]
      ,[ReportType]
      ,[Title]
      ,[Field]
      ,[Enable]
      ,[DataType]
      ,[DataLength]
      ,[DecimalPoint]
      ,[ThousandCharacter]
      ,[IsCondition]
      ,[GroupName]
      ,[GroupIndex]
      ,[IndexInGroup]
      ,[FieldWidth]
      ,[FieldIndex]
      ,[DefaultView]
      ,[Sortable]
      ,[AlignType]
      ,[FilterIndex]
      ,[BindField]
      ,[FilterType]
      ,[PointMantissa]
      ,[IsKey]
      ,[DateFormat]
      ,[EnableForXAxis]
      ,[SplitChart]
      ,[SourceDataType]
      ,[sum]
  FROM MyDataCentre_Hyde.[dbo].[DC_T_OpenBook_ColumnSetting]  where ReportType=1406

  select * from [dbo].DC_T_OpenBook_ChartSetting_MultiYAxis
  select * from [dbo].[DC_T_OpenBook_ChartSetting] order by ID desc
  select * from [dbo].[DC_T_OpenBook_Report] order by CreatedTime desc
  declare @temDay date
  --select @temDay=DateAdd (WEEK,20,'2017')
  select @temDay=DATENAME(WEEKDAY,'2017-1-1')
  print @temDay

  SELECT DATEADD(Day,24-DATEPART(Weekday,'2017'),'2017')--5

  select datepart(WEEKDAY,'2017-05-21')
 select  CAST( CONCAT(CAST( 2018 as nvarchar(100)),'-1-1')as date )	
 
 select * from TestMiddleValue order by CntrctYear asc ,CntrctWeekNum asc
 select  customer from TestMiddleValue group by customer order by CntrctYear asc ,CntrctWeekNum asc 
 select  customer from TestMiddleValue group by customer
select ID, Field2061,Field2063 from [dbo].[8e133ecd-5692-4a42-86b8-6e338f76f08d] order by Field2063
select * from TestMiddleValue
select * from TestFinalValue

select * from  MyDataCentre_Hyde.[dbo].[28beb316-1006-40fc-9003-d1aa3af8ba1f]
--87f1d5d6-9293-49a8-a708-1ceffd9f597c
execute pro_CalculateFinal
select * from [dbo].[DC_T_OpenBook_ReportType] where ReportTypeName like '%final%'
select * from [dbo]. DC_T_OpenBook_ColumnSetting where ReportType=1406
--关于起始时间，firstdate25/12/2015存在wip sales表中，但是在sales order里没有对应记录
select * from [dbo].[87f1d5d6-9293-49a8-a708-1ceffd9f597c]
select * from TestMiddleValue order by FirstDate asc
select Field3077,Field3067 from dbo.[eaa78e26-d387-4dfa-b71e-be4690feb65a] as wip order by Field3077 asc
select Field2061 from dbo.[8e133ecd-5692-4a42-86b8-6e338f76f08d] where Field2061='A71184'
select Field4559 from dbo.[239e008b-1b35-46df-a398-42af1c7fe8d7] where Field4559='A61090'
select *from dbo.[eaa78e26-d387-4dfa-b71e-be4690feb65a] as wip order by Field3077 asc
--held items 没有问题
select* from TestFinalValue where [Held Items]>0
select* from TestFinalValue where [Actual Arrears]>0

truncate table TestMiddleValue
truncate table TestFinalValue
select * from [dbo]. DC_T_OpenBook_ColumnSetting where ReportType=1406 order by ID
--4.26号改需求,如果出问题，需要保留上一周数据 ，不用清空truncate，改用带条件的delete,300多行在插入前
-- select  top 1 @NewStartDate= [Week/Year] from TestFinalValue
-- delete from [dbo].[28beb316-1006-40fc-9003-d1aa3af8ba1f] where  CONVERT(date,Field4629,120)>= CONVERT(date,@NewStartDate,120)

select Field4629, Field4637, Field4641,Field4658,Field15 from [28beb316-1006-40fc-9003-d1aa3af8ba1f]
select * from [dbo].[28beb316-1006-40fc-9003-d1aa3af8ba1f]
--truncate table [dbo].[28beb316-1006-40fc-9003-d1aa3af8ba1f]
execute pro_CalculateFinal '2018/06/20'
execute pro_CalculateFinal '2018/06/27'
execute pro_CalculateFinal
execute pro_CalculateFinal '2018/06/27'


select COUNT(*) from  TestMiddleValue where CntrctYear=2018 and CntrctWeekNum <=datepart(WEEK,'2018/06/20') or CntrctYear<=2018
select COUNT(*) from  TestMiddleValue where (CntrctYear=2018 and CntrctWeekNum <=datepart(WEEK,'2018/06/20') or CntrctYear<=2018) and Delivered is null
select SDDoc,WeekDelivered,Delivered,HELD,GROSSARREARS,NetArrears from TestMiddleValue

select COUNT(*) from TestMiddleValue where GROSSARREARS=1
select count(*) from TestMiddleValue where NetArrears!=0
select count(*) from TestMiddleValue where NetArrears=1

select SDDoc,Customer,CntrctYear,CntrctWeekNum,OSSOQt,WeekDelivered,QtyDeliv,SOQty,Delivered,DelivWeekNum,DelivYear,HELD,GROSSARREARS,NetArrears,Rescheduled from  MyDataCentre_Hyde.dbo.TestMiddleValue
--开启权限
sp_configure 'show advanced options',1
reconfigure
go
sp_configure 'xp_cmdshell',1
reconfigure
go
--导出excel，失败了，用数据库自带的导出功能
EXEC master..xp_cmdshell 'bcp MyDataCentre_Hyde.dbo.TestMiddleValue out C:/Temp.xls -c -q -S"DESKTOP-8R6EF0S" -U"sa" -P"123@abc"'

--异常数据
select * from TestMiddleValue where SDDoc='A83872'
select * from TestMiddleValue where SDDoc='A87723'

select  Delivered from TestMiddleValue group by Delivered

select SDDoc,WeekDelivered,QtyDeliv,SOQty,Delivered from TestMiddleValue 

select SDDoc,WeekDelivered,QtyDeliv,SOQty,Delivered from TestMiddleValue  where WeekDelivered=-1
-- weekdeliverd=-1正常
select distinct Delivered from TestMiddleValue  where WeekDelivered=-1
--
select distinct Delivered from TestMiddleValue  where WeekDelivered>53

select distinct Delivered  from TestMiddleValue where WeekDelivered>-1 and (CONVERT(int ,QtyDeliv)>CONVERT(int,SOQty))

select SDDoc,WeekDelivered,QtyDeliv,SOQty,Delivered from TestMiddleValue  where WeekDelivered>-1

--检查百分比
select Customer,[Actual Delivery Lines],[Arrears Delivered(Lines)],[Contracted Delivery],[Arrears Forecasted(Lines)],[DSA(contract)],[DSA(Arrears/Forecasted)],[DSA(Arrears/Forecasted C)] from MyDataCentre_Hyde.dbo.TestFinalValue 
select Customer,[Actual Delivery Lines],[Arrears Delivered(Lines)],[Contracted Delivery],[Arrears Forecasted(Lines)],[DSA(contract)],[DSA(Arrears/Forecasted)],[DSA(Arrears/Forecasted C)] from MyDataCentre_Hyde.dbo.TestFinalValue where [DSA(Arrears/Forecasted)]>0
select YearNum,WeekNum  Customer,[Actual Delivery Lines],[Contracted Delivery],[DSA(contract)],[DSA(Contract/C)] from MyDataCentre_Hyde.dbo.TestFinalValue
select SUM([Actual Delivery Lines])as [Actual Delivery Lines],
SUM([Contracted Delivery]) as [Contracted Delivery],
 CAST (SUM([Actual Delivery Lines]) as float(2))/CAST( SUM([Contracted Delivery])as float(2)) as [DSA WANT] ,
SUM([DSA(Contract/C)]) as [DSA REAL] from TestFinalValue where WeekNum =24 and YearNum=2018

select sum([DSA(Contract/C)]) from TestFinalValue where WeekNum=28 and YearNum=2018