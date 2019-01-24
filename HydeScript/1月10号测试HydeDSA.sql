select * FROM MyDataCentre_Hyde.dbo. dc_t_openbook_reporttype  order by ReportTypeId DESC

SELECT * FROM dbo.TestMiddleValue
--第一步从historic data开始 reportTypeId 1589 [2b3bb2b5-edaf-410c-abb2-d3a3f509d0a7] 导入数据
SELECT * FROM [dbo].[2b3bb2b5-edaf-410c-abb2-d3a3f509d0a7]

SELECT * FROM MyDataCentre_Hyde.dbo.DC_T_OpenBook_ColumnSetting WHERE ReportType=1589

--第二步查找新的Sales Orders 从Sales Orders DSA reportTypeId 1590 [a8f6fe54-6936-428b-a244-b99fc2f16524]
SELECT * FROM [dbo].[a8f6fe54-6936-428b-a244-b99fc2f16524]

SELECT * FROM MyDataCentre_Hyde.dbo.DC_T_OpenBook_ColumnSetting WHERE ReportType=1590

--第三步 更新middleValues的值，所有的行
--ReportTypeId 1591 WIP DSA [2e9f68d5-cd54-4a35-8481-c1ef8bfdee30] 
SELECT * FROM MyDataCentre_Hyde.dbo.DC_T_OpenBook_ColumnSetting WHERE ReportType=1591

SELECT * FROM [dbo].[2e9f68d5-cd54-4a35-8481-c1ef8bfdee30]

--第四步 Delivery DSA ReportTypeId 1592 [86c48160-fd5c-4095-849f-a766588363c5]

SELECT * FROM MyDataCentre_Hyde.dbo.DC_T_OpenBook_ColumnSetting WHERE ReportType=1592

SELECT * FROM [dbo].[86c48160-fd5c-4095-849f-a766588363c5] ORDER BY Field3

--insert data to Simple DSA 1588 [70061710-8c73-47ef-8937-09109c70481a]
SELECT * FROM MyDataCentre_Hyde.dbo.[70061710-8c73-47ef-8937-09109c70481a]

SELECT * FROM MyDataCentre_Hyde.dbo.DC_T_OpenBook_ColumnSetting WHERE ReportType=1588

SELECT * FROM [dbo].[70061710-8c73-47ef-8937-09109c70481a]

EXECUTE pro_CalculateSimple '2018-12-21'

SELECT [Week Year],DATENAME(YEAR,[Week Year]) AS [Year],
DATENAME(WEEK,[Week Year]) AS [Week],
SUM([Actual Delivery Lines]) AS [Actual], 
SUM([Contracted Delivery]) AS [Contractiv], 
SUM([DSA (contract)]) AS [DSA] ,SUM([DSA (contract C)]) AS [DSAC] FROM [dbo].TestFinalValueSimple GROUP BY [Week Year] ORDER BY [Week Year]

SELECT * FROM MyDataCentre_Hyde.dbo.TestMiddleValueSimple WHERE [Contract Deliv Date]>'2018-12-10' ORDER BY [Contract Deliv Date]

SELECT * FROM MyDataCentre_Hyde.dbo.TestFinalValueSimple WHERE Customer='AIRBUS SAS'

SELECT * FROM MyDataCentre_Hyde.dbo.TestFinalValueSimple WHERE [Week Year]>'2018-12-21' ORDER BY customer

SELECT COUNT(*) FROM MyDataCentre_Hyde.dbo.TestFinalValueSimple

TRUNCATE TABLE [dbo].[70061710-8c73-47ef-8937-09109c70481a]

SELECT * FROM [dbo].[70061710-8c73-47ef-8937-09109c70481a]