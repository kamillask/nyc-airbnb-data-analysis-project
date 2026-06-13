SELECT
	min(listingdata.rating_overall),
    max(listingdata.rating_overall)
FROM listingdata;

#average reserved days per listing
SELECT DISTINCT listing_id, avg(reserved_days) FROM pastcalendarrates
GROUP BY listing_id;

#average rate on listings
SELECT avg(ttm_avg_rate) from listingdata;

#do superhosts perform better than regular?
#Result: super hosts have better stats in every column
SELECT 
	listingdata.superhost,
    avg(listingdata.ttm_revenue) as avg_revenue,
    
    avg(listingdata.ttm_occupancy) as avg_occupancy,
    avg(listingdata.rating_overall) as avg_rating,
    avg(listingdata.num_reviews) as avg_num_reviews
FROM listingdata
GROUP BY listingdata.superhost
ORDER BY avg(listingdata.ttm_revenue);

#difference shown as a percentage
SELECT
	not_super_avg_revenue,
    super_avg_revenue,
    ((super_avg_revenue-not_super_avg_revenue)/not_super_avg_revenue)*100 as revenue_percent_difference,
    not_super_avg_occupancy,
    super_avg_occupancy,
    ((super_avg_occupancy-not_super_avg_occupancy)/not_super_avg_occupancy)*100 as occupancy_percent_difference,
    not_super_avg_rating,
    super_avg_rating,
    ((super_avg_rating-not_super_avg_rating)/not_super_avg_rating)*100 as rating_percent_difference,
    not_super_avg_num_reviews,
    super_avg_num_reviews,
    ((super_avg_num_reviews-not_super_avg_num_reviews)/not_super_avg_num_reviews)*100 as num_reviews_percent_difference
FROM (
	SELECT
		avg(CASE WHEN superhost = 0 THEN listingdata.ttm_revenue END) as not_super_avg_revenue,
		avg(CASE WHEN superhost = 1 THEN listingdata.ttm_revenue END) as super_avg_revenue,
		avg(CASE WHEN superhost = 0 THEN listingdata.ttm_occupancy END) as not_super_avg_occupancy,
		avg(CASE WHEN superhost = 1 THEN listingdata.ttm_occupancy END) as super_avg_occupancy,
		avg(CASE WHEN superhost = 0 THEN listingdata.rating_overall END) as not_super_avg_rating,
		avg(CASE WHEN superhost = 1 THEN listingdata.rating_overall END) as super_avg_rating,
		avg(CASE WHEN superhost = 0 THEN listingdata.num_reviews END) as not_super_avg_num_reviews,
		avg(CASE WHEN superhost = 1 THEN listingdata.num_reviews END) as super_avg_num_reviews
	FROM listingdata
) as super_not_super;


#same but with guest favorite, same results
SELECT 
	listingdata.guest_favorite,
    avg(listingdata.ttm_revenue) as avg_revenue,
    avg(listingdata.ttm_occupancy) as avg_occupancy,
    avg(listingdata.rating_overall) as avg_rating,
    avg(listingdata.num_reviews) as avg_num_reviews
FROM listingdata
GROUP BY listingdata.guest_favorite
ORDER BY avg(listingdata.ttm_revenue);

#percentage difference
SELECT
	not_favorite_avg_revenue,
    favorite_avg_revenue,
    ((favorite_avg_revenue-not_favorite_avg_revenue)/not_favorite_avg_revenue)*100 as revenue_percent_difference,
    not_favorite_avg_occupancy,
    favorite_avg_occupancy,
    ((favorite_avg_occupancy-not_favorite_avg_occupancy)/not_favorite_avg_occupancy)*100 as occupancy_percent_difference,
    not_favorite_avg_rating,
    favorite_avg_rating,
    ((favorite_avg_rating-not_favorite_avg_rating)/not_favorite_avg_rating)*100 as rating_percent_difference,
    not_favorite_avg_num_reviews,
    favorite_avg_num_reviews,
    ((favorite_avg_num_reviews-not_favorite_avg_num_reviews)/not_favorite_avg_num_reviews)*100 as num_ratings_percent_difference
FROM (
	SELECT	
		avg(CASE WHEN listingdata.guest_favorite = 0 THEN listingdata.ttm_revenue END) as not_favorite_avg_revenue,
        avg(CASE WHEN listingdata.guest_favorite = 1 THEN listingdata.ttm_revenue END) as favorite_avg_revenue,
        avg(CASE WHEN listingdata.guest_favorite = 0 THEN listingdata.ttm_occupancy END) as not_favorite_avg_occupancy,
        avg(CASE WHEN listingdata.guest_favorite = 1 THEN listingdata.ttm_occupancy END) as favorite_avg_occupancy,
        avg(CASE WHEN listingdata.guest_favorite = 0 THEN listingdata.rating_overall END) as not_favorite_avg_rating,
        avg(CASE WHEN listingdata.guest_favorite = 1 THEN listingdata.rating_overall END) as favorite_avg_rating,
        avg(CASE WHEN listingdata.guest_favorite = 0 THEN listingdata.num_reviews END) as not_favorite_avg_num_reviews,
        avg(CASE WHEN listingdata.guest_favorite = 1 THEN listingdata.num_reviews END) as favorite_avg_num_reviews
	FROM listingdata
) AS favorite_not_favorite;

#entire home vs room
SELECT
	listingdata.room_type,
    avg(listingdata.ttm_revenue) as avg_revenue,
    avg(listingdata.ttm_occupancy) as avg_occupancy,
    avg(listingdata.rating_overall) as avg_rating,
    avg(listingdata.num_reviews) as avg_num_reviews,
    count(listingdata.room_type) as count_room_type
FROM listingdata
GROUP BY listingdata.room_type
ORDER BY avg_revenue DESC;

#nightly rate vs occupancy rate
#min 41.5, max 1338.3
#outside of outliers, 100-200 is the best nightly rate for occupancy
SELECT
    CASE
        WHEN listingdata.ttm_avg_rate < 100 THEN '0-100'
        WHEN listingdata.ttm_avg_rate >= 100 AND listingdata.ttm_avg_rate < 200 THEN '100-200'
        WHEN listingdata.ttm_avg_rate >= 200 AND listingdata.ttm_avg_rate < 300 THEN '200-300'
        WHEN listingdata.ttm_avg_rate >= 300 AND listingdata.ttm_avg_rate < 400 THEN '300-400'
        WHEN listingdata.ttm_avg_rate >= 400 AND listingdata.ttm_avg_rate < 500 THEN '400-500'
        WHEN listingdata.ttm_avg_rate >= 500 AND listingdata.ttm_avg_rate < 600 THEN '500-600'
        WHEN listingdata.ttm_avg_rate >= 600 AND listingdata.ttm_avg_rate < 700 THEN '600-700'
        WHEN listingdata.ttm_avg_rate >= 700 AND listingdata.ttm_avg_rate < 800 THEN '700-800'
        WHEN listingdata.ttm_avg_rate >= 800 AND listingdata.ttm_avg_rate < 900 THEN '800-900'
        WHEN listingdata.ttm_avg_rate >= 900 AND listingdata.ttm_avg_rate < 1000 THEN '900-1000'
        WHEN listingdata.ttm_avg_rate >= 1000 AND listingdata.ttm_avg_rate < 1100 THEN '1000-1100'
        WHEN listingdata.ttm_avg_rate >= 1100 AND listingdata.ttm_avg_rate < 1200 THEN '1100-1200'
        WHEN listingdata.ttm_avg_rate >= 1200 AND listingdata.ttm_avg_rate < 1300 THEN '1200-1300'
        WHEN listingdata.ttm_avg_rate >= 1300 AND listingdata.ttm_avg_rate < 1400 THEN '1300-1400'
        ELSE '1400+'
    END AS price_bucket,
    avg(listingdata.ttm_occupancy) as avg_occupancy,
    count(*)
FROM listingdata
GROUP BY price_bucket
ORDER BY avg_occupancy DESC;

#same as above but with revenue
#direct correlation, higher the rate, higher the revenue
SELECT
    CASE
        WHEN listingdata.ttm_avg_rate < 100 THEN '0-100'
        WHEN listingdata.ttm_avg_rate >= 100 AND listingdata.ttm_avg_rate < 200 THEN '100-200'
        WHEN listingdata.ttm_avg_rate >= 200 AND listingdata.ttm_avg_rate < 300 THEN '200-300'
        WHEN listingdata.ttm_avg_rate >= 300 AND listingdata.ttm_avg_rate < 400 THEN '300-400'
        WHEN listingdata.ttm_avg_rate >= 400 AND listingdata.ttm_avg_rate < 500 THEN '400-500'
        WHEN listingdata.ttm_avg_rate >= 500 AND listingdata.ttm_avg_rate < 600 THEN '500-600'
        WHEN listingdata.ttm_avg_rate >= 600 AND listingdata.ttm_avg_rate < 700 THEN '600-700'
        WHEN listingdata.ttm_avg_rate >= 700 AND listingdata.ttm_avg_rate < 800 THEN '700-800'
        WHEN listingdata.ttm_avg_rate >= 800 AND listingdata.ttm_avg_rate < 900 THEN '800-900'
        WHEN listingdata.ttm_avg_rate >= 900 AND listingdata.ttm_avg_rate < 1000 THEN '900-1000'
        WHEN listingdata.ttm_avg_rate >= 1000 AND listingdata.ttm_avg_rate < 1100 THEN '1000-1100'
        WHEN listingdata.ttm_avg_rate >= 1100 AND listingdata.ttm_avg_rate < 1200 THEN '1100-1200'
        WHEN listingdata.ttm_avg_rate >= 1200 AND listingdata.ttm_avg_rate < 1300 THEN '1200-1300'
        WHEN listingdata.ttm_avg_rate >= 1300 AND listingdata.ttm_avg_rate < 1400 THEN '1300-1400'
        ELSE '1400+'
    END AS price_bucket,
    CAST(avg(listingdata.ttm_revenue) AS DECIMAL(10,2)) as avg_revenue,
    count(*)
FROM listingdata
GROUP BY price_bucket
ORDER BY avg_revenue DESC;

#which month sees the most revenue
SELECT 
    month,
    sum(revenue) as sum_revenue
FROM (
	SELECT date_format(date, '%M') as month, revenue from future_calendar_rates
    UNION ALL
    SELECT date_format(date, '%M') as month, revenue from pastcalendarrates
) AS combined
GROUP BY month
ORDER BY sum_revenue DESC;
    
#length of avg stay and revenue
SELECT
	listingdata.ttm_revenue,
    listingdata.ttm_avg_length_of_stay,
	PERCENT_RANK() OVER(ORDER BY listingdata.ttm_avg_length_of_stay)
FROM listingdata;

SELECT 
    cast(avg(listingdata.ttm_revenue) AS DECIMAL(10,2)) as avg_revenue,
    count(*),
    CASE
		WHEN listingdata.ttm_avg_length_of_stay < 6 THEN '1-5'
        WHEN listingdata.ttm_avg_length_of_stay >= 6 AND listingdata.ttm_avg_length_of_stay < 11 THEN '6-10'
        WHEN listingdata.ttm_avg_length_of_stay >= 11 AND listingdata.ttm_avg_length_of_stay < 16 THEN '11-15'
        WHEN listingdata.ttm_avg_length_of_stay >= 16 AND listingdata.ttm_avg_length_of_stay < 24 THEN '16-23'
        ELSE '24+'
	END AS avg_length_of_stay_bucket
FROM listingdata
GROUP BY avg_length_of_stay_bucket
ORDER BY avg_revenue DESC;

#do current successful listings also show better success in the future
SELECT
	f.listing_id,
    l.ttm_revenue,
	sum(f.revenue) as future_revenue,
    l.ttm_occupancy,
    avg(f.occupancy) as future_occupancy
from future_calendar_rates f
INNER JOIN listingdata l
	on l.listing_id = f.listing_id
GROUP BY f.listing_id, l.ttm_revenue, l.ttm_occupancy
ORDER BY future_revenue DESC;

#what has highest correlation with revenue?
SELECT
(
    COUNT(*) * SUM(ttm_occupancy * ttm_revenue)
    - SUM(ttm_occupancy) * SUM(ttm_revenue)
)
/
SQRT(
    (
        COUNT(*) * SUM(POW(ttm_occupancy, 2))
        - POW(SUM(ttm_occupancy), 2)
    )
    *
    (
        COUNT(*) * SUM(POW(ttm_revenue, 2))
        - POW(SUM(ttm_revenue), 2)
    )
) AS occupancy_vs_revenue,
(
    COUNT(*) * SUM(ttm_avg_rate * ttm_revenue)
    - SUM(ttm_avg_rate) * SUM(ttm_revenue)
)
/
SQRT(
    (
        COUNT(*) * SUM(POW(ttm_avg_rate, 2))
        - POW(SUM(ttm_avg_rate), 2)
    )
    *
    (
        COUNT(*) * SUM(POW(ttm_revenue, 2))
        - POW(SUM(ttm_revenue), 2)
    )
) AS ttm_avg_rate_vs_revenue,
(
    COUNT(*) * SUM(rating_overall * ttm_revenue)
    - SUM(rating_overall) * SUM(ttm_revenue)
)
/
SQRT(
    (
        COUNT(*) * SUM(POW(rating_overall, 2))
        - POW(SUM(rating_overall), 2)
    )
    *
    (
        COUNT(*) * SUM(POW(ttm_revenue, 2))
        - POW(SUM(ttm_revenue), 2)
    )
) AS rating_overall_vs_revenue,
(
    COUNT(*) * SUM(num_reviews * ttm_revenue)
    - SUM(num_reviews) * SUM(ttm_revenue)
)
/
SQRT(
    (
        COUNT(*) * SUM(POW(num_reviews, 2))
        - POW(SUM(num_reviews), 2)
    )
    *
    (
        COUNT(*) * SUM(POW(ttm_revenue, 2))
        - POW(SUM(ttm_revenue), 2)
    )
) AS num_reviews_vs_revenue,
(
    COUNT(*) * SUM(ttm_avg_length_of_stay * ttm_revenue)
    - SUM(ttm_avg_length_of_stay) * SUM(ttm_revenue)
)
/
SQRT(
    (
        COUNT(*) * SUM(POW(ttm_avg_length_of_stay, 2))
        - POW(SUM(ttm_avg_length_of_stay), 2)
    )
    *
    (
        COUNT(*) * SUM(POW(ttm_revenue, 2))
        - POW(SUM(ttm_revenue), 2)
    )
) AS ttm_avg_length_of_stay_vs_revenue,
(
    COUNT(*) * SUM(bedrooms * ttm_revenue)
    - SUM(bedrooms) * SUM(ttm_revenue)
)
/
SQRT(
    (
        COUNT(*) * SUM(POW(bedrooms, 2))
        - POW(SUM(bedrooms), 2)
    )
    *
    (
        COUNT(*) * SUM(POW(ttm_revenue, 2))
        - POW(SUM(ttm_revenue), 2)
    )
) AS bedrooms_vs_revenue,
(
    COUNT(*) * SUM(guests * ttm_revenue)
    - SUM(guests) * SUM(ttm_revenue)
)
/
SQRT(
    (
        COUNT(*) * SUM(POW(guests, 2))
        - POW(SUM(guests), 2)
    )
    *
    (
        COUNT(*) * SUM(POW(ttm_revenue, 2))
        - POW(SUM(ttm_revenue), 2)
    )
) AS guests_vs_revenue
FROM listingdata;
