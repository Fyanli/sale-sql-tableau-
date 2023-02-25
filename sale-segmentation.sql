select * from practice.sales_data_sample;
select distinct status from practice.sales_data_sample
select distinct year_id from practice.sales_data_sample
select distinct PRODUCTLINE from  practice.sales_data_sample
select distinct COUNTRY from  practice.sales_data_sample
select distinct DEALSIZE from  practice.sales_data_sample
select distinct TERRITORY from  practice.sales_data_sample

- analyse by grouping sales 

select PRODUCTLINE,sum(sales) as revenue from practice.sales_data_sample
group by PRODUCTLINE
order by 2 desc;

select year_id ,sum(sales) as revenue from practice.sales_data_sample
group by year_id 
order by 2 desc;

select  DEALSIZE,sum(sales) as revenue from practice.sales_data_sample
group by  DEALSIZE
order by 2 desc;

--what is best month in specific year? how much was earned that month?
select MONTH_ID, sum(sales) as revenue, count(ORDERNUMBER) frequency
from practice.sales_data_sample
where year_id=2004
group by MONTH_ID
order by 2 desc  

--November seems to be the best sales of month, what product do you sell
select MONTH_ID, PRODUCTLINE, sum(sales) as revenue, count(ORDERNUMBER) frequency
from practice.sales_data_sample
where year_id=2004 and MONTH_ID=11
group by MONTH_ID,PRODUCTLINE
order by 3 desc  
--classic cars are best selling product in the november

---who is our best customer? 
select customername, 
sum(sales) monetaryvalue,
avg(sales) avgmonetaryvalue,
count(ordernumber) frequency,
max(orderdate) last_order_date,
(select max(orderdate) from practice.sales_data_sample) max_order_date,
(select max(orderdate) from practice.sales_data_sample)-max(orderdate) recency 
from practice.sales_data_sample 
group by customername  

with rfm as 
(select customername, 
sum(sales) monetaryvalue,
avg(sales) avgmonetaryvalue,
count(ordernumber) frequency,
max(orderdate) last_order_date,
(select max(orderdate) from practice.sales_data_sample) max_order_date,
(select max(orderdate) from practice.sales_data_sample)-max(orderdate) recency 
from practice.sales_data_sample 
group by customername)

select r.*,  NTILE(4) OVER (order by r.recency desc) rfm_recency,
           NTILE(4) OVER (order by r.frequency) rfm_frequency,
		   NTILE(4) OVER (order by r.monetaryvalue) rfm_monetary
	       from rfm r
           
           
select customername, 
sum(sales) monetaryvalue,
avg(sales) avgmonetaryvalue,
count(ordernumber) frequency,
max(orderdate) last_order_date,
(select max(orderdate) from practice.sales_data_sample) max_order_date,
(select max(orderdate) from practice.sales_data_sample)-max(orderdate) recency 
from practice.sales_data_sample 
group by customername  

with rfm as 
(select customername, 
sum(sales) monetaryvalue,
avg(sales) avgmonetaryvalue,
count(ordernumber) frequency,
max(orderdate) last_order_date,
(select max(orderdate) from practice.sales_data_sample) max_order_date,
(select max(orderdate) from practice.sales_data_sample)-max(orderdate) recency 
from practice.sales_data_sample 
group by customername),
rfm_calc as 
(select r.*,  NTILE(4) OVER (order by r.recency desc) rfm_recency,
           NTILE(4) OVER (order by r.frequency) rfm_frequency,
		   NTILE(4) OVER (order by r.monetaryvalue) rfm_monetary
	       from rfm r),
segment as 
(select c.*, rfm_recency+ rfm_frequency+ rfm_monetary as rfm_cell,
concat(rfm_recency, rfm_frequency,rfm_monetary ) as rfm_cell_string
from rfm_calc c)

select s.customername, rfm_recency, rfm_frequency, rfm_monetary,
	case 
		when rfm_cell_string in (111, 112 , 121, 122, 123, 132, 211, 212, 114, 141) then 'lost_customers'  
		when rfm_cell_string in (133, 134, 143, 244, 334, 343, 344, 144) then 'slipping away, cannot lose' 
		when rfm_cell_string in (311, 411, 331) then 'new customers'
		when rfm_cell_string in (222, 223, 233, 322) then 'potential churners'
		when rfm_cell_string in (323, 333,321, 422, 332, 432) then 'active' 
		when rfm_cell_string in (433, 434, 443, 444) then 'loyal'
	end rfm_segment
from segment s

           

 















