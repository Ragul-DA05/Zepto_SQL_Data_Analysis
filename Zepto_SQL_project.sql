create database zepto_sql_project;
use zepto_sql_project;
create table zepto(
sku_id int Auto_Increment primary key,
category varchar(100),
name varchar(120) not null,
mrp decimal(8,2),
discountPrecent decimal(5,2),
availableQuantity int,
discountedSellingPrice decimal(8,2),
weightinGms int,
outofstock enum('TRUE','FALSE'),
quantity int
);

#Data Exploration
#Counting Datas
select count(*) from zepto;

#Sample Data
select * from zepto limit 10;

#Null Values Checking
select * from zepto where name is null
or
category is null
or
mrp is null
or
discountPrecent is null
or  
availableQuantity is null
or
discountedSellingPrice is null
or
weightinGms is null
or
outofstock is null
or
quantity is null;

#Diffrent Product Categories
select distinct category from zepto group by category;

#Product in stock vs out of stock
select outofstock, count(sku_id) from zepto group by outofstock;

#Product Name Present Multipletimes
select name ,count(*) as multiple_times from zepto group by name having multiple_times > 1 order by multiple_times desc;

#Data cleaning
#Checking price of product = 0
select * from zepto where mrp = 0
or
discountedSellingPrice = 0;
# Its not Possible so deleting the column
delete from zepto where mrp=0;

#converting paise to Rupeess
update zepto set mrp = mrp/100.0,discountedSellingPrice=discountedSellingPrice/100.0;
select * from zepto limit 10;

# Find the Top 10 valuable Products Based on their Discount Percentage
select distinct name,mrp,discountPrecent from zepto order by discountPrecent desc limit 10;

#What are the product with high Mrp but Outofstock
select distinct name,max(mrp) from zepto where outofstock = "TRUE" group by name order by max(mrp) desc;

#Calculate estimated revenue for each category
select category,sum(discountedSellingPrice * availableQuantity ) as revenue from zepto group by category order by revenue desc;

#Find all product where Mrp is greater than 500 and discount is less than 10%
select distinct name,mrp,discountPrecent from zepto where mrp >500 and discountPrecent < 10 order by mrp desc ,discountPrecent desc;

#identifying the top 5 categories offering the highest average discount percentage
select category , avg(discountPrecent) as Average from zepto group by category order by average desc limit 5;

#Find the price per gram for product above 100g and sort by best values
select distinct name , weightinGms,discountedSellingPrice,round(discountedSellingPrice/weightinGms,2) as price_per_gram from zepto where weightinGms >= 100 order by Price_per_gram;

#Group the Product into Categories like low,Medium,bulk
select distinct name,weightinGms,
case when weightinGms < 1000 then "low"
when weightinGms < 5000 then "Medium"
else "Bulk"
end as Weight_category
from zepto;

#what is the total inventory weight per category
select category,sum(weightinGms *availableQuantity ) as Total_weight from zepto group by category order by Total_weight;


