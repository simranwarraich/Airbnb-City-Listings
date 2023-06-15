---Viewing the dataset
SELECT *  FROM third-flare-385112.AirBnb_NewYork_City_Listings.listings order by id LIMIT 1000;

---Data  processing
---Used concat,AVG,min,max,distinct

SELECT distinct COUNT(*) FROM `third-flare-385112.AirBnb_NewYork_City_Listings.listings`;  #No duplicates found 42931
SELECT DISTINCT count(host_name) FROM `third-flare-385112.AirBnb_NewYork_City_Listings.listings`; #42926
Select longitude from `third-flare-385112.AirBnb_NewYork_City_Listings.listings` where longitude <0;
select distinct room_type from `third-flare-385112.AirBnb_NewYork_City_Listings.listings`;   #Four
select min(price) as MinP , max(price) as MaxP from third-flare-385112.AirBnb_NewYork_City_Listings.listings;
select count(*) from AirBnb_NewYork_City_Listings.listings where price = 0; #Total 27 records, donot include in analysis

select count(*) as listings,concat('$',round(AVG(price),2) ) as Average_price , round(AVG(number_of_reviews),2) as average_reviews 
from AirBnb_NewYork_City_Listings.listings where price>0;

---Analysis
---Summary of each neighbourhood in a specific neighbourhood group 
---Using stored procedure 

drop procedure if exists AirBnb_NewYork_City_Listings.summaryoflistings;
create procedure AirBnb_NewYork_City_Listings.summaryoflistings
( neighbourhood_grp string)
BEGIN
SELECT neighbourhood_group, neighbourhood,count(id) as no_of_listings, concat("$",ROUND(AVG(price),2)) AS average_price,min(price) 
as min_price, max(price) as max_pricve,ROUND(AVG(number_of_reviews),2) as average_reviews,
CONCAT(ROUND(AVG(availability_365/3.65),2),"%") as average_availability_365
FROM `third-flare-385112.AirBnb_NewYork_City_Listings.listings`
WHERE neighbourhood_group = neighbourhood_grp and price > 0
GROUP BY neighbourhood , neighbourhood_group
ORDER BY neighbourhood;
END;

CALL AirBnb_NewYork_City_Listings.summaryoflistings("Bronx");
CALL AirBnb_NewYork_City_Listings.summaryoflistings("Brooklyn");
CALL AirBnb_NewYork_City_Listings.summaryoflistings("Manhattan");
CALL AirBnb_NewYork_City_Listings.summaryoflistings('Queens');
CALL AirBnb_NewYork_City_Listings.summaryoflistings("Staten Island");

---Summary by each neighbourhood group 
SELECT neighbourhood_group, count(id) as total_listings, concat("$",round(avg(price),2)) as average_price, 
round(avg(number_of_reviews),2) as average_reviews, CONCAT(ROUND(AVG(availability_365/3.65),2),"%") as average_availability_365
FROM AirBnb_NewYork_City_Listings.listings
WHERE price> 0
GROUP BY neighbourhood_group
ORDER BY neighbourhood_group;

---Summary by room type
SELECT room_type, count(id) as no_of_listings, concat("$",round(avg(price),2)) as average_price, 
round(avg(number_of_reviews),2) as average_reviews, CONCAT(ROUND(AVG(availability_365/3.65),2),"%")
as average_availability_365
FROM AirBnb_NewYork_City_Listings.listings
WHERE  price> 0
GROUP BY room_type
ORDER BY room_type;




