select *, concat(R,F,M) as RFM from (
select CustomerID, recency ,frequency , monetary , case when recency >= 9 and recency < 40 then '4'
				     when recency >= 40 and recency < 68 then '3'
				     when recency >= 68 and recency < 80 then '2'
				     else '1' end as R ,

				     case when frequency >= 1 and frequency < 2 then '1'
				     when frequency >= 2 and frequency < 3 then '2'
				     when frequency >= 3 and frequency < 4 then '3'
				     else '4' end as F,

				     case when monetary >= 0 and monetary < 50000 then '1'
				     when monetary >= 50000 and monetary < 100000 then '2'
				     when monetary >= 100000 and monetary < 1000000 then '3'
				     else '4' end as M
				     from dbo.CRM_RFM_SUMMARY crs  ) A

select min(frequency),max(frequency),avg(frequency) from dbo.CRM_RFM_SUMMARY crs

select * into #temp from (
select *, concat(R,F,M) as RFM from (
select CustomerID, recency ,frequency , monetary , case when recency >= 9 and recency < 40 then '4'
				     when recency >= 40 and recency < 68 then '3'
				     when recency >= 68 and recency < 80 then '2'
				     else '1' end as R ,

				     case when frequency >= 1 and frequency < 2 then '1'
				     when frequency >= 2 and frequency < 3 then '2'
				     when frequency >= 3 and frequency < 4 then '3'
				     else '4' end as F,

				     case when monetary >= 0 and monetary < 50000 then '1'
				     when monetary >= 50000 and monetary < 100000 then '2'
				     when monetary >= 100000 and monetary < 1000000 then '3'
				     else '4' end as M
				     from dbo.CRM_RFM_SUMMARY crs  ) A )B

select RFM, count(*) as totalcustomers from #Temp group by RFM
order by totalcustomers desc

select CustomerID,recency,frequency,monetary,
NTILE(4) over (order by recency desc) as R,
NTILE(4) over (order by frequency desc) as F,
NTILE(4) over (order by monetary desc) as M from dbo.CRM_RFM_SUMMARY
order by R desc