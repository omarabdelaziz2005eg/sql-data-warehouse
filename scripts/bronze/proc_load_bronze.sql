CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN 
DECLARE @start_time datetime,@end_time datetime,@batch_start_time datetime,@batch_end_time datetime;
set @batch_start_time = getdate();
BEGIN try
print'----';
print'loading bronze layer';
print'----';
print'---';
print 'loading crm tables';
print'---';
set @start_time=getdate();
bulk insert bronze.crm_cust_info 
from 'C:\omar\cust_info.csv'
with (firstrow=2,fieldterminator=',',tablock);
set @end_time=getdate();
print '>>load duration:'+cast(datediff(second,@start_time,@end_time)as nvarchar)+'seconds'
print'-----'
bulk insert bronze.crm_prd_info 
from 'C:\omar\prd_info.csv'
with (firstrow=2,fieldterminator=',',tablock)
bulk insert bronze.crm_sales_details 
from 'C:\omar\sales_details.csv'
with (firstrow=2,fieldterminator=',',tablock)
print'---';
print 'loading erp tables';
print'---';
bulk insert bronze.erp_loc_a101 
from 'C:\omar\LOC_A101.csv'
with (firstrow=2,fieldterminator=',',tablock)
bulk insert bronze.erp_cust_az12 
from 'C:\omar\CUST_AZ12.csv'
with (firstrow=2,fieldterminator=',',tablock)
bulk insert bronze.erp_px_cat_g1v2 
from 'C:\omar\PX_CAT_G1V2.csv'
with (firstrow=2,fieldterminator=',',tablock);
set @batch_end_time=getdate();
print cast(datediff(second,@batch_start_time,@batch_end_time)as nvarchar);
END TRY
BEGIN CATCH
PRINT'=============';
PRINT'ERROR';
PRINT 'ERROR_MESSAGE()';
PRINT 'CAST(ERROR_NUMBER() AS NVARCHAR)';
PRINT'--------------';
END CATCH
END
