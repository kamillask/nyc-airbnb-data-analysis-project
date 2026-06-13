SELECT * FROM future_calendar_rates;

SELECT 
	booked_rate_avg,
    booking_lead_time_avg,
    length_of_stay_avg,
    native_booked_rate_avg
FROM future_calendar_rates
WHERE
	booked_rate_avg = ''
    OR booking_lead_time_avg = ''
    OR length_of_stay_avg = ''
    OR native_booked_rate_avg = '';

#updating all blank values into null
UPDATE nyc_airbnb_data.future_calendar_rates
SET
	booked_rate_avg = nullif(booked_rate_avg, ''),
    booking_lead_time_avg = nullif(booking_lead_time_avg, ''),
    length_of_stay_avg = nullif(length_of_stay_avg, ''),
    native_booked_rate_avg = nullif(native_booked_rate_avg, ''),
    min_nights_avg = nullif(min_nights_avg, '');


DESCRIBE nyc_airbnb_data.future_calendar_rates;

#setting data types back into appropriate types
ALTER TABLE nyc_airbnb_data.future_calendar_rates
MODIFY COLUMN date DATE,
MODIFY COLUMN vacant_days INT,
MODIFY COLUMN reserved_days INT,
MODIFY COLUMN occupancy DECIMAL(10,3),
MODIFY COLUMN revenue DECIMAL(10,1),
MODIFY COLUMN rate_avg DECIMAL(10,1),
MODIFY COLUMN booked_rate_avg DECIMAL(10,1),
MODIFY COLUMN booking_lead_time_avg INT,
MODIFY COLUMN length_of_stay_avg INT,
MODIFY COLUMN min_nights_avg INT,
MODIFY COLUMN native_booked_rate_avg DECIMAL(10,1),
MODIFY COLUMN native_rate_avg DECIMAL(10,1),
MODIFY COLUMN native_revenue DECIMAL(10,1);