SELECT * FROM listingdata;
DESCRIBE listingdata;

#setting null values for empty rows
UPDATE nyc_airbnb_data.listingdata
SET
    photos_count = NULLIF(photos_count, ''),
    guests = NULLIF(guests, ''),
    bedrooms = NULLIF(bedrooms, ''),
    cleaning_fee = NULLIF(cleaning_fee, ''),
    extra_guest_fee = NULLIF(extra_guest_fee, ''),
    checkin_time = NULLIF(checkin_time, ''),
    checkout_time = NULLIF(checkout_time, ''),
    rating_overall = NULLIF(rating_overall, ''),
    rating_accuracy = NULLIF(rating_accuracy, ''),
    rating_checkin = NULLIF(rating_checkin, ''),
    rating_cleanliness = NULLIF(rating_cleanliness, ''),
    rating_communication = NULLIF(rating_communication, ''),
    rating_location = NULLIF(rating_location, ''),
    rating_value = NULLIF(rating_value, '');
    
#setting false on missing values, standardize true/false to 1 and 0
select 
	instant_book,
	case
		when instant_book = '' then 0
        when instant_book = 'FALSE' then 0
        when instant_book = 'TRUE' then 1
        else 0
	end
from listingdata;

UPDATE nyc_airbnb_data.listingdata
SET
	instant_book = 
		CASE
			WHEN instant_book = '' then 0
            WHEN instant_book = 'FALSE' then 0
            WHEN instant_book = 'TRUE' then 1
            ELSE 0
		END,
	professional_management = 
		CASE
			WHEN professional_management = '' then 0
            WHEN professional_management = 'FALSE' then 0
            WHEN professional_management = 'TRUE' then 1
            ELSE 0
		END,
    guest_favorite = 
		CASE
			WHEN guest_favorite = '' then 0
            WHEN guest_favorite = 'FALSE' then 0
            WHEN guest_favorite = 'TRUE' then 1
            ELSE 0
		END,
    exact_location = 
		CASE
			WHEN exact_location = '' then 0
            WHEN exact_location = 'FALSE' then 0
            WHEN exact_location = 'TRUE' then 1
            ELSE 0
		END,
    single_fee_structure = 
		CASE
			WHEN single_fee_structure = '' then 0
            WHEN single_fee_structure = 'FALSE' then 0
            WHEN single_fee_structure = 'TRUE' then 1
            ELSE 0
		END,
	superhost = 
		CASE
			WHEN superhost = '' then 0
            WHEN superhost = 'FALSE' then 0
            WHEN superhost = 'TRUE' then 1
            ELSE 0
		END,
	registration = 
		CASE
			WHEN registration = '' then 0
            WHEN registration = 'FALSE' then 0
            WHEN registration = 'TRUE' then 1
            ELSE 0
		END
    ;
    
UPDATE nyc_airbnb_data.listingdata
SET
	superhost = 
		CASE
			WHEN superhost = '' then 0
            WHEN superhost = 'FALSE' then 0
            WHEN superhost = 'TRUE' then 1
            ELSE 0
		END,
	registration = 
		CASE
			WHEN registration = '' then 0
            WHEN registration = 'FALSE' then 0
            WHEN registration = 'TRUE' then 1
            ELSE 0
		END
    ;

ALTER TABLE listingdata
MODIFY COLUMN instant_book TINYINT(1),
MODIFY COLUMN professional_management TINYINT(1),
MODIFY COLUMN guest_favorite TINYINT(1),
MODIFY COLUMN exact_location TINYINT(1),
MODIFY COLUMN single_fee_structure TINYINT(1),
MODIFY COLUMN superhost TINYINT(1),
MODIFY COLUMN registration TINYINT(1);
    
#cleaning time
select 
	checkin_time,
    left(checkin_time, locate(':', checkin_time)-1),
    right(checkin_time, 2),
    str_to_date(concat(left(checkin_time, locate(':', checkin_time)-1), ':00', right(checkin_time, 2)), '%h:%i%p')
from listingdata;

UPDATE nyc_airbnb_data.listingdata
SET
	checkin_time = str_to_date(concat(left(checkin_time, locate(':', checkin_time)-1), ':00', right(checkin_time, 2)), '%h:%i%p'),
    checkout_time = str_to_date(concat(left(checkout_time, locate(':', checkout_time)-1), ':00', right(checkout_time, 2)), '%h:%i%p');
    
ALTER TABLE listingdata
MODIFY COLUMN checkin_time TIME,
MODIFY COLUMN checkout_time TIME;

#converting remaining columns to correct data types
ALTER TABLE listingdata
MODIFY COLUMN photos_count INT,
MODIFY COLUMN guests INT,
MODIFY COLUMN bedrooms INT,
MODIFY COLUMN beds INT,
MODIFY COLUMN baths INT,
MODIFY COLUMN cleaning_fee INT,
MODIFY COLUMN extra_guest_fee INT,
MODIFY COLUMN rating_overall DECIMAL(3,2),
MODIFY COLUMN rating_accuracy DECIMAL(2,1),
MODIFY COLUMN rating_checkin DECIMAL(2,1),
MODIFY COLUMN rating_cleanliness DECIMAL(2,1),
MODIFY COLUMN rating_communication DECIMAL(2,1),
MODIFY COLUMN rating_location DECIMAL(2,1),
MODIFY COLUMN rating_value DECIMAL(2,1),
MODIFY COLUMN ttm_revenue INT,
MODIFY COLUMN ttm_revenue_native INT;

	