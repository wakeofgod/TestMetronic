USE MyDataCentre_Hyde
go

--清除原有的middleValues表
IF NOT  EXISTS (SELECT * FROM sys.objects WHERE name='TestMiddleValueSimple')
 BEGIN
  CREATE TABLE TestMiddleValueSimple
  (
  Id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
  [Sales Doc.] NVARCHAR(100) ,
  [Contract Deliv Date] DATE,
  [S/O Qty] int,
  [Qty Deliv] int,
  [Cntrct Week Num] INT,
  [Cntrct Year] INT ,
  [Delivered] NVARCHAR(100),
  [Customer] NVARCHAR(100)
  )
 END
 GO
 IF NOT  EXISTS(SELECT * FROM sys.objects WHERE name='TestFinalValueSimple')
	BEGIN
	 CREATE TABLE TestFinalValueSimple
	 (
		Id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
		[Week Year] DATE,
		[Contracted Delivery] INT ,
		[Actual Delivery Lines] INT ,
		[DSA (contract)] FLOAT(2),
		[DSA (contract C)] FLOAT(2),
		Customer				NVARCHAR(100),
	 )
	END   
GO
IF EXISTS (select * from sys.objects where name='pro_CalculateFinal ')
	BEGIN
		DROP PROCEDURE pro_CalculateFinal
	END 
GO
 CREATE PROCEDURE pro_CalculateFinal
 (@inputDate date=null)
 AS 
	BEGIN
		DECLARE @Id INT,
				@SalesDoc NVARCHAR(100),
				@FirstDate DATE,
				@SoQty INT ,
				@SumDelivery  INT,
				@CntrctWeekNum INT,
				@CntrctYear    INT,
				@QtyDeliv INT,
				@Delievered nvarchar(100),
				@NewStartDate						DATE,
				@NewEndDate							DATE,
				@MinYear							INT,
				@MaxYear							INT,
				@MaxWeek							INT,
				@MinWeek							INT,
				@Customer							NVARCHAR(100),
				@ContractedDelivery					INT,
				@ActualDeliveryLines				INT,
				@DSAcontract						FLOAT(2),
				@DSAcontractC						FLOAT(2),
				@TotalContractedDelivery			INT

-- force first day of week is monday
  set datefirst 1
  --clear data for temporary,need change
  TRUNCATE TABLE TestMiddleValueSimple
  TRUNCATE TABLE TestFinalValueSimple
  --import data from Historic Dataset ,just in first time ,need add judgment
    INSERT INTO [dbo].TestMiddleValueSimple
  (
      [Sales Doc.],
      [Contract Deliv Date],
      [S/O Qty],
      [Qty Deliv],
      [Cntrct Week Num],
      [Cntrct Year],
      Delivered,
      Customer
  )
  SELECT Field3,Field4,Field5,Field6,NULL,NULL,NULL,Field7
  FROM [dbo].[2b3bb2b5-edaf-410c-abb2-d3a3f509d0a7]

  --import new Sales Doc  from Sales Orders DSA, condition :Sales Doc not in TestMiddleValueSimple
    INSERT INTO [dbo].TestMiddleValueSimple
  (
      [Sales Doc.],
      [Contract Deliv Date],
      [S/O Qty],
      [Qty Deliv],
      [Cntrct Week Num],
      [Cntrct Year],
      Delivered,
      Customer
  )
SELECT  Field3,NULL,NULL,NULL,NULL,NULL,NULL,Field5
	FROM [dbo].[a8f6fe54-6936-428b-a244-b99fc2f16524]
	WHERE Field3 NOT IN (SELECT  [Sales Doc.] FROM [dbo].TestMiddleValueSimple) 
	
  --update Contract Deliv Date AND S/O Qty from WIP DSA	   
  DECLARE Cur_Contract CURSOR 
  FOR SELECT Id,[Sales Doc.] FROM [dbo].TestMiddleValueSimple
  OPEN Cur_Contract
  FETCH NEXT FROM Cur_Contract INTO @Id,@SalesDoc
  WHILE @@FETCH_STATUS=0
	BEGIN
		SELECT TOP 1 @SoQty= Field12,@FirstDate= field14 FROM [dbo].[2e9f68d5-cd54-4a35-8481-c1ef8bfdee30] WHERE Field3=@SalesDoc
		IF @FirstDate IS NOT NULL AND @SoQty IS NOT NULL
			BEGIN
			  UPDATE  [dbo].TestMiddleValueSimple SET [Contract Deliv Date]=@FirstDate,[S/O Qty]=@SoQty WHERE Id=@Id and [Contract Deliv Date] is null
			END           
	    FETCH NEXT FROM Cur_Contract INTO @Id,@SalesDoc
	END
 CLOSE Cur_Contract
 DEALLOCATE Cur_Contract  

  --update QTY DELIV from Delivery DSA
 DECLARE Cur_Delivery  CURSOR
 FOR SELECT Id,[Sales Doc.],[Contract Deliv Date] FROM [dbo].TestMiddleValueSimple    
 OPEN Cur_Delivery
 FETCH NEXT FROM Cur_Delivery INTO @Id,@SalesDoc,@FirstDate
 WHILE @@FETCH_STATUS=0
	BEGIN
		SELECT @SumDelivery=SUM(CAST( field8 as int)) FROM [dbo].[86c48160-fd5c-4095-849f-a766588363c5] WHERE field3=@SalesDoc AND Field13!=@FirstDate
		IF @SumDelivery IS NOT NULL
			BEGIN
				UPDATE [dbo].TestMiddleValueSimple set [Qty Deliv]=ISNULL([Qty Deliv],0)+ @SumDelivery WHERE Id=@Id
			END           		
		FETCH NEXT FROM Cur_Delivery INTO @Id,@SalesDoc,@FirstDate
	END
CLOSE Cur_Delivery
DEALLOCATE Cur_Delivery  

--update Cntrct Week Num, Cntrct Year and Delivered  
declare Cur_Delevered Cursor
for SELECT Id,[Sales Doc.],[Contract Deliv Date],[S/O Qty],[Qty Deliv] from [dbo].TestMiddleValueSimple
open Cur_Delevered
FETCH next from Cur_Delevered into @Id,@SalesDoc,@FirstDate,@SoQty,@QtyDeliv
while @@FETCH_STATUS=0
	begin		
		SELECT @CntrctWeekNum=null,@CntrctYear=null
		if @FirstDate IS NOT NULL
			BEGIN
				SELECT @CntrctWeekNum=DATENAME(WEEK,@FirstDate)
				SELECT @CntrctYear=DATENAME(YEAR,@FirstDate)
				--PRINT '456'
			END
         ELSE 
			PRINT 'date is null'   
		IF @QtyDeliv is null or @QtyDeliv=0
			BEGIN
				SELECT @Delievered=N'Not Delivered'
			END
		ELSE IF @QtyDeliv<@SoQty
			BEGIN
				SELECT @Delievered=N'Part Delivered'
			END            
		ELSE
			SELECT @Delievered=N'Delivered'
		update [dbo].TestMiddleValueSimple set [Cntrct Week Num]=@CntrctWeekNum,[Cntrct Year]=@CntrctYear,Delivered=@Delievered where Id=@Id
		FETCH next from Cur_Delevered into @Id,@SalesDoc,@FirstDate,@SoQty,@QtyDeliv
	end
CLOSE Cur_Delevered
DEALLOCATE Cur_Delevered
--generate start date and end date
if @inputDate is null
	BEGIN
		 SELECT @NewStartDate=DATEADD(WEEK,-1,GETDATE())
		 SELECT @NewEndDate=DATEADD(WEEK,50,GETDATE())
	END
else
	BEGIN
		 SELECT @NewStartDate=DATEADD(WEEK,-1,@inputDate)
	     SELECT @NewEndDate=DATEADD(WEEK,50,@inputDate)
	END
   SELECT @MinYear= DATENAME(YEAR,@NewStartDate)
   SELECT @MaxYear=DATENAME(YEAR,@NewEndDate)
   SELECT @MinWeek=DATENAME(WEEK,@NewStartDate)
   SELECT @MaxWeek=DATENAME(WEEK,@NewEndDate)

    DECLARE @YearNum INT,
		   @WeekNum INT,
		   @TempWeek INT,
		   @TempDay  DATE,
		   @TempFirstDay DATE,
		   @weekDay  INT
	SELECT @YearNum=@MinYear
	WHILE @YearNum<=@MaxYear
		BEGIN
			IF @YearNum=@MinYear
				SELECT @WeekNum=@MinWeek
			ELSE 
				SELECT @WeekNum=1
			IF @YearNum=@MaxYear
				SELECT @TempWeek=@MaxWeek
			ELSE 
				SELECT @TempWeek=53
			WHILE @WeekNum<=@TempWeek
				BEGIN
					--first date of every year
					SELECT @TempFirstDay= CAST( CONCAT(CAST( @YearNum as nvarchar(100)),'-1-1')as date )
					SELECT @weekDay=DATEPART(WEEKDAY,@TempFirstDay)
					SELECT @TempDay=DATEADD(WEEK,@WeekNum-1,@TempFirstDay)
					SELECT @TempDay=DATEADD(DAY,1-@weekDay,@TempDay)
					DECLARE Cur_SimpleCustomer CURSOR 
					FOR SELECT customer FROM TestMiddleValueSimple GROUP BY customer
					OPEN Cur_SimpleCustomer
					FETCH NEXT FROM Cur_SimpleCustomer INTO @Customer
					WHILE @@FETCH_STATUS=0
						BEGIN
							IF NOT EXISTS (SELECT * FROM [dbo].TestFinalValueSimple WHERE [Week Year]=@TempDay AND Customer=@Customer)
								BEGIN
									INSERT INTO  [dbo].TestFinalValueSimple([Week Year],[Contracted Delivery],[Actual Delivery Lines],[DSA (contract)],[DSA (contract C)],Customer) VALUES(@TempDay,NULL,NULL,NULL,NULL,@Customer)
								END 
							FETCH NEXT FROM Cur_SimpleCustomer INTO @Customer
						END    
					CLOSE Cur_SimpleCustomer
					DEALLOCATE Cur_SimpleCustomer
					SELECT @WeekNum+=1	                   
				END 
				SELECT @YearNum+=1
		END      

	DECLARE Cur_CalFinal CURSOR
	FOR SELECT Id,[Week Year],Customer FROM [dbo].TestFinalValueSimple
	OPEN Cur_CalFinal
	FETCH NEXT FROM Cur_CalFinal INTO @Id,@FirstDate,@Customer
	WHILE @@FETCH_STATUS=0
		BEGIN
			--清空数据
			SELECT @DSAcontract=0,@ContractedDelivery=0,@ActualDeliveryLines=0,@TotalContractedDelivery=0,@DSAcontractC=0
			SELECT @ContractedDelivery=ISNULL(COUNT(*),0)  FROM [dbo].TestMiddleValueSimple WHERE Customer=@Customer AND DATENAME(WEEK,@FirstDate)=DATENAME(WEEK,[Contract Deliv Date]) AND DATENAME(YEAR,@FirstDate)=DATENAME(YEAR,[Contract Deliv Date])
			SELECT @ActualDeliveryLines=ISNULL(COUNT(*),0) FROM [dbo].TestMiddleValueSimple WHERE Customer=@Customer AND DATENAME(WEEK,@FirstDate)=DATENAME(WEEK,[Contract Deliv Date]) AND DATENAME(YEAR,@FirstDate)=DATENAME(YEAR,[Contract Deliv Date]) AND Delivered='Delivered'
			SELECT @TotalContractedDelivery=ISNULL(COUNT(*),0) FROM [dbo].TestMiddleValueSimple WHERE  DATENAME(WEEK,@FirstDate)=DATENAME(WEEK,[Contract Deliv Date]) AND DATENAME(YEAR,@FirstDate)=DATENAME(YEAR,[Contract Deliv Date])
			IF @ContractedDelivery!=0
				BEGIN
					SELECT @DSAcontractC= CAST(@ActualDeliveryLines as float(2))/CAST( @ContractedDelivery as float(2))                
				END 
			IF @TotalContractedDelivery!=0
				BEGIN
 					SELECT @DSAcontract= CAST(@ActualDeliveryLines as float(2))/CAST(@TotalContractedDelivery as float(2))               
				END 
			UPDATE [dbo].TestFinalValueSimple SET [Contracted Delivery]=@ContractedDelivery,[Actual Delivery Lines]=@ActualDeliveryLines,[DSA (contract C)]=@DSAcontractC,[DSA (contract)]=@DSAcontract WHERE Id=@Id
			FETCH NEXT FROM Cur_CalFinal INTO @Id,@FirstDate,@Customer
        END 
	CLOSE Cur_CalFinal
	DEALLOCATE Cur_CalFinal

--insert data to Simple DSA
	IF EXISTS (SELECT * from sys.objects WHERE name='70061710-8c73-47ef-8937-09109c70481a' AND type='u')
		BEGIN
			SELECT  top 1 @NewStartDate= [Week Year] from TestFinalValueSimple
			DELETE FROM [dbo].[70061710-8c73-47ef-8937-09109c70481a] WHERE  CONVERT(date,Field3,120)>= CONVERT(date,@NewStartDate,120)
			INSERT INTO [dbo].[70061710-8c73-47ef-8937-09109c70481a]
			(ClientID,
			Field3,
			Field4,
			Field5,
			Field6,
			Field7,
			Field8)
			SELECT 
			3,
			[Week Year],
			[Contracted Delivery],
			[Actual Delivery Lines] ,
			[DSA (contract)],
			[DSA (contract C)] ,
			Customer							
			FROM [dbo].TestFinalValueSimple
		END 

   SET datefirst 7
	END

