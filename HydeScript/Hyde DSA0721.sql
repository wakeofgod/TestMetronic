-- =============================================
-- Author:		JL
-- Create date: 2018-7-21
-- Description:	use three tables calculate the final value
-- =============================================
--===============================================
--Dynamic table names and column names don't know how to deal with this, so I'm going to do this locally fixed
--  in local database
--  sales orders :reportType 241, datasource:dbo.[8e133ecd-5692-4a42-86b8-6e338f76f08d]  column SD Doc. is Field2061
--																						 column customer is field 2063
--  WIP Sales    :reportType 1242 datasource:dbo.[eaa78e26-d387-4dfa-b71e-be4690feb65a]  column Sales Doc. is Field3067
--																						 column Sales O/S Sales Order Qty is Field3090
--																						 column First Date is Field3077
--																						 column Order Quantity is Field3083
--																						 column Service Render Date is Field3078
--  New Delivery Report:reportType��1395 datasource:[239e008b-1b35-46df-a398-42af1c7fe8d7] column Delivery Date is Field4558
--																						 column Delivery quantity is Field4557
--																						 column Sales Order is  Field4559
/****** Object:  StoredProcedure [dbo].[pro_CalculateFinal]    Script Date: 2018/3/12 16:51:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
if  exists(select * from sysobjects where id=OBJECT_ID('TestFinalValue') and [type]='U')
drop table TestFinalValue
go
		create table TestFinalValue
		(
			Id int identity(1,1) primary key not null,
			"Week/Year" date not null,
			Customer				nvarchar(100),
			YearNum				  int,
			WeekNum				  int,
			"Contracted Delivery" int ,
			"Actual Delivery Lines" int,
			"Arrears Forecasted(Lines)" int,
			"Arrears Delivered(Lines)" int,
			"Rescheduled Dates"   int,
			"Forecast Arrears"    int,
			"Actual Arrears"	  int,
			"Held Items"		  int,
			"DSA(contract)"       float(2),
			"DSA(Arrears/Forecasted)" float(2),
			"Target DSA"		float(2),
			"Projected Arrears" float(2),
			"DSA(Contract/C)"   float(2),
			"DSA(Arrears/Forecasted C)" float(2)
		)
go
if exists(select * from sysobjects where id=OBJECT_ID('TestMiddleValue')and [type]='U')
drop table TestMiddleValue
go
create table TestMiddleValue
(
id   int identity(1,1) primary key not null,
		SDDoc nvarchar(100),
		Customer nvarchar(100),
		CntrctWeekNum int,
		CntrctYear    int,
		OSSOQt		  nvarchar(100),
		WeekDelivered int,
		QtyDeliv      nvarchar(100),
		SOQty	      nvarchar(100),
		Delivered     nvarchar(100),		
		DelivWeekNum  int,
		DelivYear     int,
		HELD		  int,
		GROSSARREARS  int,
		NetArrears    int,
		Rescheduled   nvarchar(100),
		FirstDate     date ,
		ServiceRenderDate date    
)
go
if  exists(select * from sys.objects where name='pro_CalculateFinal ')
drop procedure pro_CalculateFinal
go
create procedure pro_CalculateFinal
(@inputDate date=null)
as
begin
	declare
			@SdDocField							nvarchar(100),
			@FirstDate							nvarchar(100),
			@DeliveryDate						nvarchar(100),
			@WipSalesDoc						nvarchar(100),
			@Id									int,
			@CntrctWeekNum						int,			--MIDDLE VALUES 
			@CntrctYear							int,			--MIDDLE VALUES 
			@OSSOQt							    nvarchar(100),  --MIDDLE VALUES 
			@WeekDelivered						int,			--MIDDLE VALUES 
			@QtyDeliv							nvarchar(100),  --MIDDLE VALUES
			@SOQty								nvarchar(100),  --MIDDLE VALUES
			@Delivered							nvarchar(100),  --MIDDLE VALUES
			@ContractDelivDate					nvarchar(100),
			@ServiceRenderDate					nvarchar(100),
			@DelivWeekNum						int,			--MIDDLE VALUES
			@DelivYear							int,			--MIDDLE VALUES
			@HELD								int,			--MIDDLE VALUES
			@GROSSARREARS						int,			--MIDDLE VALUES
			@NetArrears							int,            --MIDDLE VALUES
			@Rescheduled						nvarchar(100),  --MIDDLE VALUES
			@MinYear							int,
			@MaxYear							int,
			@MaxWeek							int,
			@MinWeek							int,
			@ContractedDelivery					int,			--Final Values
			@ActualDeliveryLines				int,			--Final Values
			@ArrearsForecastedLines		        int,			--Final Values
			@ArrearsDeliveredLines				int,			--Final Values
			@RescheduledDates					int,			--Final Values
			@ForecastArrears					int,			--Final Values
			@ActualArrears						int,			--Final Values
			@HeldItems							int,			--Final Values
			@DSAcontract						float(2),		--Final Values
			@DSAArrearsForecasted				float(2),		--Final Values
			@TargetDSA							float(2),		--Final Values
			@Customer							nvarchar(100),
			@ProjectedArrears                   float(2),
			@NewStartDate						date,
			@NewEndDate							date,
			@DSAcontractC						float(2),		--Final Values 7��21����������
			@DSAArrearsForecastedC				float(2),		--Final Values 7��21����������
			@TotalContractedDelivery			int,			--��ĸ����ʱ��ͳ��ContractedDelivery������
			@TotalArrearsForecastedLines		int				--��ĸ����ʱ��ͳ��ArrearsForecastedLines������
	create table #tmp
	(
		id   int identity(1,1) primary key not null,
		SDDoc nvarchar(100),
		Customer nvarchar(100),
		CntrctWeekNum int,
		CntrctYear    int,
		OSSOQt		  nvarchar(100),
		WeekDelivered int,
		QtyDeliv      nvarchar(100),
		SOQty	      nvarchar(100),
		Delivered     nvarchar(100),		
		DelivWeekNum  int,
		DelivYear     int,
		HELD		  int,
		GROSSARREARS  int,
		NetArrears    int,
		Rescheduled   nvarchar(100),
		FirstDate     date,
		ServiceRenderDate date       
	)
	truncate table TestMiddleValue
    truncate table TestFinalValue
	set datefirst 1
   declare Cur_Middle cursor
   for select ID, Field2061,Field2063 from [dbo].[8e133ecd-5692-4a42-86b8-6e338f76f08d] 
   open Cur_Middle
   fetch next from Cur_Middle into @Id,@SdDocField,@Customer
   while @@FETCH_STATUS=0
		begin
			select @FirstDate='',@OSSOQt='0',@DeliveryDate='',@ContractDelivDate='',@ServiceRenderDate='',@QtyDeliv=0,@SOQty=0
			select top 1 @FirstDate= ISNULL( Field3077,''),@OSSOQt=ISNULL( Field3090,'0'),@SOQty= Field3083,@ContractDelivDate=ISNULL( Field3077,''),@ServiceRenderDate=ISNULL(Field3078,'') 
			from dbo.[eaa78e26-d387-4dfa-b71e-be4690feb65a] wip where wip.Field3067=@SdDocField
				if @FirstDate!=''
				begin
					--print @FirstDate
					select @CntrctWeekNum=DATENAME(WEEK,@FirstDate)
					select @CntrctYear=DATENAME(YEAR,@FirstDate)
					--print @CntrctWeekNum
				end	
				if @ServiceRenderDate!=''
				begin
					select @DelivWeekNum=DATENAME(WEEK,@ServiceRenderDate)
					select @DelivYear=DATENAME(YEAR,@ServiceRenderDate)
				end	
				else
					begin
						select @DelivWeekNum=-1,@DelivYear=-1
					end
			select top 1 @DeliveryDate= ISNULL( Field4558,'' ),@QtyDeliv=ISNULL( Field4557,'') from [dbo].[239e008b-1b35-46df-a398-42af1c7fe8d7] newDelivery where newDelivery.Field4559=@SdDocField
			if @DeliveryDate!=''
				begin
					select @WeekDelivered=DATENAME(WEEK,@DeliveryDate)
				end
			else
				select @WeekDelivered=-1
			if (datepart(MONTH,@ContractDelivDate)=12 AND DATEPART(YEAR,@ContractDelivDate)=2015 and DATENAME(DAY,@ContractDelivDate)=25) or(datepart(MONTH,@ServiceRenderDate)=12 AND DATEPART(YEAR,@ServiceRenderDate)=2015 and DATENAME(DAY,@ServiceRenderDate)=25)
					select @HELD=1
			else
					select @HELD=0
			if @WeekDelivered>53
					select @Delivered='Not Delivered'
			else if CONVERT(int, @QtyDeliv)<CONVERT(int, @SOQty) and @WeekDelivered!=-1
					select @Delivered='Part Delivered'
			else if @WeekDelivered=-1
					select @Delivered=null		
			else if CONVERT(int, @QtyDeliv)>=CONVERT(int, @SOQty) and @WeekDelivered!=-1
					select @Delivered='Delivered'
			if @ServiceRenderDate>@ContractDelivDate
					select @Rescheduled='Rescheduled'
			else 
					select @Rescheduled='No Change'
			if @Delivered is null
				begin
					if DATEDIFF(DAY,@ContractDelivDate,GETDATE())>0
						select @GROSSARREARS=1
					else
						select @GROSSARREARS=0
				end
			else if @Delivered='Part Delivered'
				begin
					if DATEDIFF(DAY,@ContractDelivDate,GETDATE())>0
						select @GROSSARREARS=1
					else
						select @GROSSARREARS=0
				end
			else
				select @GROSSARREARS=0
			if @GROSSARREARS <@HELD
				select @NetArrears=0
			else 
				select @NetArrears=@GROSSARREARS-@HELD
            if @FirstDate!=''
				begin
					insert into #tmp(SDDoc,CntrctWeekNum,CntrctYear,OSSOQt,WeekDelivered,QtyDeliv,SOQty,Delivered,DelivWeekNum,DelivYear,HELD,GROSSARREARS,NetArrears,Rescheduled,FirstDate,ServiceRenderDate,Customer)
			        values(@SdDocField,@CntrctWeekNum,@CntrctYear,@OSSOQt,@WeekDelivered,@QtyDeliv,@SOQty,@Delivered,@DelivWeekNum,@DelivYear,@HELD,@GROSSARREARS,@NetArrears,@Rescheduled,@FirstDate,@ServiceRenderDate,@Customer) 
					insert into TestMiddleValue(SDDoc,CntrctWeekNum,CntrctYear,OSSOQt,WeekDelivered,QtyDeliv,SOQty,Delivered,DelivWeekNum,DelivYear,HELD,GROSSARREARS,NetArrears,Rescheduled,FirstDate,ServiceRenderDate,Customer)
					values(@SdDocField,@CntrctWeekNum,@CntrctYear,@OSSOQt,@WeekDelivered,@QtyDeliv,@SOQty,@Delivered,@DelivWeekNum,@DelivYear,@HELD,@GROSSARREARS,@NetArrears,@Rescheduled,@FirstDate,@ServiceRenderDate,@Customer)
				end
			fetch next from Cur_Middle into @Id,@SdDocField,@Customer
		end
   close Cur_Middle
   deallocate Cur_Middle
   --sales order have 8791 pieces of data��wip sales have 4583 pieces of data, so need to filter some data
   --select * from #tmp order by CntrctYear asc,CntrctWeekNum asc
   --4��26�Ÿ��߼�����ʼ���ǵ�ǰ�ܵ���һ�ܣ��������ǵ�ǰ�ܼ�9���ܹ�11�ܵ�����,���Ҳ���ǿ�һ�꣬��Ҫ�ж�һ��
   --ÿһ�μ��㶼���������ٸ���
   --6��14�Ÿ��߼���held items��Actual Arrears ��ǰ�ܺ��Ժ�Ķ������㣬��һ����ǰ�ļ���
   --��������⣺��ȡʱ��� ÿ�μ��� ���ϵ�ʱ�� ����ǰ�ܵľ��ܺ�DSA��պ� ���²��뵽DSA���У�
   --���Ǽ�����һ�ܵ����ܺ�ɾ��DSA����һ�ܵ����ܺ�����ݣ����������ݣ�����һ�֣�����һ��ʱ����е��,���кܶ���������
   if @inputDate is null
		begin
			   select @NewStartDate=DATEADD(WEEK,-1,GETDATE())
			   select @NewEndDate=DATEADD(WEEK,9,GETDATE())
		end
  else
		begin
			   select @NewStartDate=DATEADD(WEEK,-1,@inputDate)
			   select @NewEndDate=DATEADD(WEEK,9,@inputDate)
		end
   select @MinYear= DATENAME(YEAR,@NewStartDate)
   select @MaxYear=DATENAME(YEAR,@NewEndDate)
   select @MinWeek=DATENAME(WEEK,@NewStartDate)
   select @MaxWeek=DATENAME(WEEK,@NewEndDate)
   declare @YearNum int,
		   @WeekNum int,
		   @TempWeek int,
		   @TempDay  date,
		   @TempFirstDay date,
		   @weekDay  int
	select @YearNum=@MinYear 
	while @YearNum<=@MaxYear
		begin
			if @YearNum=@MinYear
				select @WeekNum=@MinWeek
			else
				select @WeekNum=1 
			if @YearNum=@MaxYear 
				select @TempWeek=@MaxWeek
			else 
				select @TempWeek=53		      
			while @WeekNum<=@TempWeek
				begin
					--���ÿ���һ�����ܼ���
					select @TempFirstDay= CAST( CONCAT(CAST( @YearNum as nvarchar(100)),'-1-1')as date )
					select @weekDay=DATEPART(WEEKDAY,@TempFirstDay)
					select @TempDay=DATEADD(week,@WeekNum-1,@TempFirstDay)
					select @TempDay=DATEADD(day,2-@weekDay,@TempDay)		
					--insert into TestFinalValue([Week/Year],YearNum,WeekNum) values( CONCAT( cast( @WeekNum as nvarchar(100)),'/',cast( @YearNum as nvarchar(100))),@YearNum,@WeekNum)
					declare Cur_FinalCus cursor
					 for select  customer from TestMiddleValue group by customer
					 open Cur_FinalCus
					 fetch next from Cur_FinalCus into @Customer
					 while @@FETCH_STATUS=0
						begin							
							insert into TestFinalValue([Week/Year],YearNum,WeekNum,Customer) values( @TempDay,@YearNum,@WeekNum,@Customer)
							fetch next from Cur_FinalCus into @Customer
						end
					close 	Cur_FinalCus
					deallocate Cur_FinalCus
					select @WeekNum+=1
				end
				select @YearNum+=1
		end

  declare Cur_CalFinal Cursor 
  for select WeekNum,YearNum,Customer ,Id from TestFinalValue 
  open Cur_CalFinal
  fetch next from Cur_CalFinal into @WeekNum,@YearNum,@Customer, @Id
  while @@FETCH_STATUS=0
		begin
			select @ContractedDelivery=0,@ContractedDelivery=0,@ActualDeliveryLines=0,@ArrearsForecastedLines=0,@ArrearsDeliveredLines=0,@RescheduledDates=0,@ActualArrears=0,@MinYear=0,@DSAcontract=0.00,@DSAArrearsForecasted=0.00,@DSAcontractC=0.00,@DSAArrearsForecastedC=0.00
			select @ContractedDelivery=ISNULL( count(*),0) from #tmp where CntrctWeekNum=@WeekNum and CntrctYear=@YearNum and Customer=@Customer
			select @ActualDeliveryLines=ISNULL( COUNT(*),0) from #tmp where CntrctWeekNum=@WeekNum and CntrctYear=@YearNum and WeekDelivered<=53 and Delivered='Delivered' and WeekDelivered!=-1 and Customer=@Customer
			select @ArrearsForecastedLines=ISNULL( COUNT(*),0) from #tmp where DelivWeekNum=@WeekNum and DelivYear=@YearNum and Rescheduled='Rescheduled' and Customer=@Customer
			select @ArrearsDeliveredLines=ISNULL( COUNT(*),0) from #tmp where DelivYear=@YearNum and DelivWeekNum=@WeekNum and WeekDelivered<53 and WeekDelivered!=-1 and Customer=@Customer
			select @RescheduledDates=ISNULL( COUNT(*),0) from #tmp where CntrctWeekNum=@WeekNum and CntrctYear=@YearNum and Rescheduled='Rescheduled' and Customer=@Customer
            if (@WeekNum=DATENAME(WEEK,@NewStartDate) and @YearNum=DATENAME(YEAR,@NewStartDate))
				begin
					--������ held��actual�����޹�
					select @HeldItems= COUNT(*) from #tmp where  HELD=1 and Customer=@Customer
					select @ActualArrears=ISNULL( COUNT(*),0) from #tmp where  NetArrears=1  and Customer=@Customer
				end
			else
			   select @HeldItems=null,@ActualArrears=null
			--ÿ���һ�ܵ���һ����ȥ������һ��
			if @WeekNum!=1
				begin
					if exists( select * from TestFinalValue where YearNum=@YearNum and WeekNum=@WeekNum-1)
						begin
							--�������⽨���������ֳɵ�,@MaxYear,@MinYear���ﲻ������
							--@MaxYear�����һ�ܵ�Actual Arrears 
							--@MaxWeek�����һ�ܵ�[Forecast Arrears]
							select @MaxYear=ISNULL([Actual Arrears],0),@MaxWeek=ISNULL([Forecast Arrears],0)  from TestFinalValue where YearNum=@YearNum and WeekNum=@WeekNum-1 and Customer=@Customer
							if @MaxYear!=0
								begin
									select @MinYear=COUNT(*) from #tmp where DelivWeekNum=@WeekNum and DelivYear=@YearNum and NetArrears=1 and Customer=@Customer
									select @ForecastArrears=@MaxYear-@MinYear
									select @ProjectedArrears=@MaxYear+@RescheduledDates-@ForecastArrears
								end
							else if @MaxYear=0 
								begin
									select @MinYear=COUNT(*) from #tmp where DelivWeekNum=@WeekNum and DelivYear=@YearNum and NetArrears=1 and Customer=@Customer
									select @ForecastArrears=@MaxWeek-@MinYear
									--ȡ���ܵ�Forecasted Arrears
									select @MaxYear=ISNULL([Forecast Arrears],0) from TestFinalValue where YearNum=@YearNum and WeekNum=@WeekNum-1 and Customer=@Customer
									select @ProjectedArrears=@MaxYear+@RescheduledDates-@ActualArrears
								end
						end
					else
					  select @ForecastArrears=0,@ProjectedArrears=0
				end	
			else
				begin
					if exists( select * from TestFinalValue where YearNum=@YearNum-1 and WeekNum=52)
						begin
							select @MaxYear=ISNULL([Actual Arrears],0),@MaxWeek=ISNULL([Forecast Arrears],0)  from TestFinalValue where YearNum=@YearNum-1 and WeekNum=52 and Customer=@Customer
							if @MaxYear!=0
								begin
									select @MinYear=COUNT(*) from #tmp where DelivWeekNum=52 and DelivYear=@YearNum-1 and NetArrears=1 and Customer=@Customer
									select @ForecastArrears=@MaxYear-@MinYear
									select @ProjectedArrears=@MaxYear+@RescheduledDates-@ForecastArrears
								end
							else if @MaxYear=0 
								begin
									select @MinYear=COUNT(*) from #tmp where DelivWeekNum=52 and DelivYear=@YearNum-1 and NetArrears=1 and Customer=@Customer
									select @ForecastArrears=@MaxWeek-@MinYear
									select @MaxYear=ISNULL([Forecast Arrears],0) from TestFinalValue where YearNum=@YearNum-1 and WeekNum=52 and Customer=@Customer
									select @ProjectedArrears=@MaxYear+@RescheduledDates-@ActualArrears
								end
						end
					else 
						select @ForecastArrears=0,@ProjectedArrears=0
				end		
			--�����Ϳͻ��޹�,ֻ����ʱ��
			select @TotalContractedDelivery=ISNULL( count(*),0) from #tmp where CntrctWeekNum=@WeekNum and CntrctYear=@YearNum
			select @TotalArrearsForecastedLines=ISNULL( COUNT(*),0) from #tmp where DelivWeekNum=@WeekNum and DelivYear=@YearNum and Rescheduled='Rescheduled'
			if @ContractedDelivery!=0 
				begin
					select @DSAcontractC= cast(@ActualDeliveryLines as float(2))/cast( @ContractedDelivery as float(2))
					select @DSAcontract= cast(@ActualDeliveryLines as float(2))/cast(@TotalContractedDelivery as float(2))			
				end	
			if (@ActualDeliveryLines+@ArrearsDeliveredLines!=0) and(@ContractedDelivery+@ArrearsForecastedLines!=0)
				begin
					--select @DSAArrearsForecasted=(cast( @ContractedDelivery as float(2) )+cast( @ArrearsForecastedLines as float(2)))/(CAST( @ActualDeliveryLines as float(2))+cast( @ArrearsDeliveredLines as float(2)))	
					select @DSAArrearsForecastedC=(cast( @ActualDeliveryLines as float(2) )+cast( @ArrearsDeliveredLines as float(2)))/(CAST( @ContractedDelivery as float(2))+cast( @ArrearsForecastedLines as float(2)))	
					select @DSAArrearsForecasted=(cast( @ActualDeliveryLines as float(2) )+cast( @ArrearsDeliveredLines as float(2)))/(CAST( @TotalContractedDelivery as float(2))+cast( @TotalArrearsForecastedLines as float(2)))	
				end			
			select @TargetDSA=0.75
			update TestFinalValue set [Contracted Delivery]=@ContractedDelivery,
									  [Actual Delivery Lines]=@ActualDeliveryLines,
									  [Arrears Forecasted(Lines)]=@ArrearsForecastedLines,
									  [Arrears Delivered(Lines)]=@ArrearsDeliveredLines,
									  [Rescheduled Dates]=@RescheduledDates,
									  [Forecast Arrears]=@ForecastArrears,
									  [Actual Arrears]=@ActualArrears,
									  [Held Items]=@HeldItems,
									  [DSA(contract)]=@DSAcontract,
									  [DSA(Arrears/Forecasted)]=@DSAArrearsForecasted,
									  [Target DSA]=@TargetDSA,
									  [Projected Arrears]=@ProjectedArrears,
									  [DSA(Contract/C)]=@DSAcontractC,
									  [DSA(Arrears/Forecasted C)]=@DSAArrearsForecastedC
									   where Id=@Id
			fetch next from Cur_CalFinal into @WeekNum,@YearNum,@Customer,@Id
		end
  close Cur_CalFinal
  deallocate Cur_CalFinal
  -- insert into dataset , must be built in advance,table name and columns not the same ,must change it by Manual operation
  if exists(select * from sys.objects where name='e777923c-87fc-45f7-bf76-920868df7355' and type='u')
	begin
		 select  top 1 @NewStartDate= [Week/Year] from TestFinalValue
		 delete from [dbo].[e777923c-87fc-45f7-bf76-920868df7355] where  CONVERT(date,Field4648,120)>= CONVERT(date,@NewStartDate,120)
		 insert into [dbo].[e777923c-87fc-45f7-bf76-920868df7355]
			(
			ClientID,
			Field4648,
			Field4649,
			Field4650,
			Field4651,
			Field4652,
			Field4653,
			Field4654,
			Field4655,
			Field4656,
			Field4657,
			Field4658,
			Field4659,
			Field15,
			Field16,
			Field17
			)select 
			3,
			[Week/Year],
			[Contracted Delivery],
			[Actual Delivery Lines],
			[Arrears Forecasted(Lines)],
			[Arrears Delivered(Lines)],
			[Rescheduled Dates],
			[Actual Arrears],
			[Forecast Arrears],
			[Held Items],
			[DSA(contract)],
			[DSA(Arrears/Forecasted)],
			[Customer],
			[Projected Arrears],
			[DSA(Contract/C)],
			[DSA(Arrears/Forecasted C)]
			from [dbo].[TestFinalValue]
	end
 
   drop table #tmp
   set datefirst 7
end