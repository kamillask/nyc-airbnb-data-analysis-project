SELECT * FROM pastcalendarrates;
DESCRIBE pastcalendarrates;

UPDATE nyc_airbnb_data.pastcalendarrates
SET
	booked_rate_avg = nullif(booked_rate_avg, ''),
    booking_lead_time_avg = nullif(booking_lead_time_avg, ''),
    length_of_stay_avg = nullif(length_of_stay_avg, ''),
    native_booked_rate_avg = nullif(native_booked_rate_avg, ''),
    min_nights_avg = nullif(min_nights_avg, '');

ALTER TABLE pastcalendarrates
MODIFY COLUMN date DATE,
MODIFY COLUMN vacant_days INT,
MODIFY COLUMN reserved_days INT,
MODIFY COLUMN occupancy DECIMAL(4,3),
MODIFY COLUMN revenue DECIMAL(10,2),
MODIFY COLUMN rate_avg DECIMAL(10,2),
MODIFY COLUMN booked_rate_avg DECIMAL(10,2),
MODIFY COLUMN booking_lead_time_avg INT,
MODIFY COLUMN length_of_stay_avg INT,
MODIFY COLUMN min_nights_avg INT,
MODIFY COLUMN native_booked_rate_avg DECIMAL(10,2),
MODIFY COLUMN native_rate_avg DECIMAL(10,2),
MODIFY COLUMN native_revenue DECIMAL(10,2);